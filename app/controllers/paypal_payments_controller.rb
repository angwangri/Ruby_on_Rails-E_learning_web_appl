#!/bin/env: ruby
#encoding: utf-8

class PaypalPaymentsController < ApplicationController
require "paypal/recurring"
require 'digest/md5'
require 'uri'
require 'net/http'
require 'net/https'

def featured_payment_monthly
  featured_payment(PaypalPayment::MONTH)
end

def featured_payment_yearly
    featured_payment(PaypalPayment::YEAR)
end

def featured_payment(subscription_type)
  @user = User.find_by_id(params[:id])
  ppr = PayPal::Recurring.new({
    :return_url   => "http://#{request.host_with_port}" + "/paypal_payments/review/#{@user.id}?type=#{subscription_type}",
    :cancel_url   => "http://#{request.host_with_port}" + "/paypal_payments/cancel/#{@user.id}",
    :description  => get_recurring_payment_description(subscription_type),
    :amount       => get_recurring_payment_amount(subscription_type),
    :currency     => get_recurring_payment_currency
  })
  response = ppr.checkout
  redirect_to response.checkout_url if response.valid? 
end  

def review
  @user = User.find_by_id(params[:id])
  unless (params["token"].blank? && params[:PayerID].blank?)
    @paypal_payment = PaypalPayment.new(:user_id => @user.id,token: params["token"], payer_id: params["PayerID"], :subscription_type => params[:type])
    @paypal_payment.save
    make_recurring(@paypal_payment)
  else
    redirect_to :action => "cancel", :id=> @user.id
  end  
end

  def make_recurring(paypal_payment)
    @paypal_payment = paypal_payment
    ppr_recurring = PayPal::Recurring.new({
        :amount      => get_recurring_payment_amount(@paypal_payment.subscription_type),
        :currency    => get_recurring_payment_currency,
        :description => get_recurring_payment_description(@paypal_payment.subscription_type),
        :frequency   => 1,
        :token       => "#{@paypal_payment.token}",
        :period      => (@paypal_payment.subscription_type == PaypalPayment::MONTH) ? :monthly : :yearly,
        :payer_id    => "#{@paypal_payment.payer_id}",
        :start_at    => Time.now,
      })
      recurring = ppr_recurring.create_recurring_profile
      puts recurring.to_json
      if(recurring.ack.downcase == "success")
        pay_response = make_payment(@paypal_payment)
        if (pay_response.approved? && pay_response.completed?)
          @paypal_payment.update(:profile_id => recurring.profile_id, :profile_status=> PaypalPayment::ACTIVE, :start_date=> Time.now.to_date) if recurring.profile_id
          @paypal_payment.user.user_detail.update(:listing_type => false,:is_plan_selected? => true) if recurring.profile_id
          flash[:notice] = "Thanks for the Payment!! Your recurring profile has been created successfully."
        else
          flash[:notice] = "Sorry!! Payment cannot be completed. Please try again."
        end
      else
        flash[:notice] = "Your recurring profile has not been created."        
      end
      redirect_to :controller => "user_details", :action => "my_account", :id => @paypal_payment.user.user_detail.id
  end

  def make_payment(payment_detail)
    @paypal_payment = payment_detail
    ppr = PayPal::Recurring.new({
      :token       => "#{@paypal_payment.token}",
      :payer_id    => "#{@paypal_payment.payer_id}",
      :amount      => get_recurring_payment_amount(@paypal_payment.subscription_type),
      :description => get_recurring_payment_description(@paypal_payment.subscription_type)
    })
    response = ppr.request_payment
  end

  def cancel
    @user = User.find_by_id(params[:id])
    redirect_to :controller => "tutors", :action=>"upgrade", :id=>@user.user_detail.id
  end

  def cancel_recurring
    @paypal_payment = User.find(params[:id]).paypal_payments.last
    ppr = PayPal::Recurring.new(:profile_id => @paypal_payment.profile_id)
    res = ppr.cancel
    if(res.ack.downcase == "success")  
      @paypal_payment.update(:profile_status=> PaypalPayment::CANCEL)
      flash[:notice] = "Your recurring profile has been cancelled successfully."
    else
      flash[:error] = "Sorry!! Your recurring profile cannot be cancelled. Please try again."
    end
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paypal_payment
      @paypal_payment = PaypalPayment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def paypal_payment_params
      params.require(:paypal_payment).permit(:user_id, :payer_id, :token, :profile_id, :subscription_type, :profile_status, :start_date)
    end
end

#response
#<PayPal::Recurring::Response::Payment:0xd51b8d4 @response=#<Net::HTTPOK 200 OK readbody=true>, @params={:TOKEN=>"EC-7G373229L34997232", :SUCCESSPAGEREDIRECTREQUESTED=>"false", :TIMESTAMP=>"2013-12-20T09:56:26Z", :CORRELATIONID=>"a97ec7e2244b3", :ACK=>"Success", :VERSION=>"72.0", :BUILD=>"8951431", :INSURANCEOPTIONSELECTED=>"false", :SHIPPINGOPTIONISDEFAULT=>"false", :PAYMENTINFO_0_TRANSACTIONID=>"3D411814UE533882N", :PAYMENTINFO_0_TRANSACTIONTYPE=>"expresscheckout", :PAYMENTINFO_0_PAYMENTTYPE=>"instant", :PAYMENTINFO_0_ORDERTIME=>"2013-12-20T09:56:26Z", :PAYMENTINFO_0_AMT=>"9.00", :PAYMENTINFO_0_FEEAMT=>"0.56", :PAYMENTINFO_0_TAXAMT=>"0.00", :PAYMENTINFO_0_CURRENCYCODE=>"USD", :PAYMENTINFO_0_PAYMENTSTATUS=>"Completed", :PAYMENTINFO_0_PENDINGREASON=>"None", :PAYMENTINFO_0_REASONCODE=>"None", :PAYMENTINFO_0_PROTECTIONELIGIBILITY=>"Ineligible", :PAYMENTINFO_0_PROTECTIONELIGIBILITYTYPE=>"None", :PAYMENTINFO_0_SECUREMERCHANTACCOUNTID=>"YFE2XJ7BX59S2", :PAYMENTINFO_0_ERRORCODE=>"0", :PAYMENTINFO_0_ACK=>"Success"}>

#recurring
#{"response":{"server":["Apache"],"content-length":["316"],"content-type":["text/plain; charset=utf-8"],"dc":["origin2-api-3t.sandbox.paypal.com"],"date":["Fri, 20 Dec 2013 09:56:39 GMT"],"connection":["close"],"set-cookie":["DC=origin2-api-3t.sandbox.paypal.com; secure"]}}

#ppr_recurring
#<PayPal::Recurring::Base:0xc952868 @description="TutorApp - Yearly Subscription", @amount="89.00", @currency="USD", @frequency=1, @token="EC-19D317902Y3916022", @period=:yearly, @payer_id="2HNHUW7USJ6AU", @start_at=2013-12-20 00:05:01 +0530>