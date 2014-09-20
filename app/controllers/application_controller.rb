#!/bin/env ruby
# encoding: utf-8

class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers
  #before_filter :set_charset
  #def set_charset
  #  @headers["Content-Type"] = "text/html; charset=utf-8"
  #end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found        
  protect_from_forgery with: :exception, :except => ['/users/sign_in']
  helper_method :redirect_after_sign_in, :resource, :resource_name, :devise_mapping
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  
  

  def record_not_found
    render  "home/page_not_found", status: 404
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
 
  def set_locale
    session[:locale] = params[:locale] if params[:locale]
    I18n.locale = session[:locale] || I18n.default_locale
  end


	def get_recurring_payment_amount(subscription_type)
		(subscription_type == PaypalPayment::MONTH) ? "10.00" : "82.00"
	end

	def get_recurring_payment_description(subscription_type)
		(subscription_type == PaypalPayment::MONTH) ? "SouFudao - Monthly Subscription" : "SouFudao - Yearly Subscription"
	end

	def get_recurring_payment_currency
		return "USD"
	end
	
	def after_sign_in_path_for(user)
    redirect_after_sign_in(user)
  end

  def redirect_after_sign_in(user)
    if (user.user_detail && (stored_location_for(user) == "/tutors/my_messages/#{user.user_detail.id}"))
      "/tutors/my_messages/#{user.user_detail.id}"
    elsif (!user.is_tutor? && (stored_location_for(user) == "/tutors/student_messages/#{user.id}"))
      "/tutors/student_messages/#{user.id}"
    else
      if user.user_detail.present?
        if user.user_detail.is_profile_and_listing_done? 
          if user.is_tutor?
            if user.user_detail.get_count_of_new_msgs > 0
              "/tutors/my_messages/#{user.user_detail.id}" #route to message
            else
              "/user_details/my_account/#{user.user_detail.id}"
            end
          end  
        elsif user.user_detail.is_user_profile_done? 
          "/user_details/#{user.user_detail.id}/profile_completion_step3" 
        else 
          "/user_details/#{user.user_detail.id}/profile_completion_step2"
        end 
      elsif user.is_tutor? != true
          if user.get_count_of_new_msgs > 0
            "/tutors/student_messages/#{user.id}" #route to message
          else
           "/tutors/student/#{user.id}"
          end            
      else
        "/"
      end      
    end
  end    
  	
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :first_name
    devise_parameter_sanitizer.for(:sign_up) << :last_name
  end
end
