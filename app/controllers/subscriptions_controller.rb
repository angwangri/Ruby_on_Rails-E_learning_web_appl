#!/bin/env: ruby
#encoding: utf-8

class SubscriptionsController < ApplicationController
  protect_from_forgery with: :exception, :except => ['request_to_yoopay']
  require 'digest/md5'

  def request_to_yoopay
    user_id = params[:id]
    language = session[:locale] == 'cn' ? 'zh' : 'en'
    post_url = Subscription.generete_payment_url(params[:payment_type],user_id,language)
    redirect_to post_url
  end

  def notify_url
    @subscription = Subscription.find_by_tid(params[:tid]) 
    if params && @subscription
      response = params      
        if response[:result_status] == "1"
            @subscription.update_attributes(:yapi_tid => response[:yapi_tid], 
                                :tid => response[:tid], 
                                :item_price => response[:item_price], 
                                :item_currency => response[:item_currency],
                                :result_status => response[:result_status], 
                                :result_desc => response[:result_desc], 
                                :start_date => Time.now , 
                                :status => Subscription::ACTIVE)
            @subscription.user.user_detail.update(:listing_type => false,:is_plan_selected? => true)
            puts "Thanks for the Payment!! Your premium profile has been created successfully."
        elsif response[:result_status] == "0"
            @subscription.update_attributes(:yapi_tid => response[:yapi_tid], 
                                :tid => response[:tid], 
                                :item_price => response[:item_price], 
                                :item_currency => response[:item_currency],
                                :result_status => response[:result_status], 
                                :result_desc => response[:result_desc], 
                                :start_date => nil , 
                                :status => Subscription::PENDING)          
          puts "Your payment is pending for approval."  
        else
          puts "Your premium profile has not been created."  
        end
    else
      puts "An error occured. Please try again later."  
    end
    render :text => params
  end

  def return_url
    @subscription = Subscription.find_by_tid(params[:tid]) 
    if params && @subscription
      response = params      
        if response[:result_status] == "1"
            @subscription.update_attributes(:yapi_tid => response[:yapi_tid], 
                                :tid => response[:tid], 
                                :item_price => response[:item_price], 
                                :item_currency => response[:item_currency],
                                :result_status => response[:result_status], 
                                :result_desc => response[:result_desc], 
                                :start_date => Time.now , 
                                :status => Subscription::ACTIVE)
            @subscription.user.user_detail.update(:listing_type => false,:is_plan_selected? => true)
            flash[:notice] = "Thanks for the Payment!! Your premium profile has been created successfully."
        elsif response[:result_status] == "0"
            @subscription.update_attributes(:yapi_tid => response[:yapi_tid], 
                                :tid => response[:tid], 
                                :item_price => response[:item_price], 
                                :item_currency => response[:item_currency],
                                :result_status => response[:result_status], 
                                :result_desc => response[:result_desc], 
                                :start_date => nil , 
                                :status => Subscription::PENDING)          
          flash[:notice] = "Your payment is pending for approval."  
        else
          flash[:notice] = "Your premium profile has not been created."  
        end
    else
      flash[:notice] = "An error occured. Please try again later."  
    end
      redirect_to :controller => "user_details", :action => "my_account", :id => current_user.user_detail.id
  end

  def cancel
    @user = User.find_by_id(params[:id])
    redirect_to :controller => "tutors", :action=>"upgrade", :id=>@user.user_detail.id
  end

  def cancel_subscription
    #TODO
  end
end
