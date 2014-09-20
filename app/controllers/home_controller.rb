#!/bin/env: ruby
#encoding: utf-8

class HomeController < ApplicationController
  def index
    location = request.location.data['city'] + ',' + request.location.data['country_code']
    if location.present? && location != ',RD' && location != ','
        @user_details = UserDetail.where('listing_type = ?', false).near(location, 15000)
      else
        @user_details = UserDetail.where('listing_type = ?', false)
    end
  end

  def save_contact
  	unless (params[:message][:email].blank? && params[:message][:message].blank? && params[:message][:name].blank?)
  		UserMailer.send_feedback_to_admin(params[:message][:email],params[:message][:message],params[:message][:name]).deliver
  		flash[:notice] = (session[:locale] != "cn") ? "Thank you for your Feedback! We value your comments and will respond to your questions as soon as we can."
      : "谢谢您的反馈！如有问题，我们会尽快回复您。"
  	else
  		flash[:error] = (session[:locale] != "cn") ? "Please enter an email address and message."
      : "请输入邮件和信息。"
  	end
  	redirect_to :back
  end

  def search_tutors 
      city_states = YAML.load_file('config/city_states.yml')
      @cities = city_states['china'].keys
      @districts = city_states['china']['Shanghai']
   
    location = request.location.data['city'] + ',' + request.location.data['country_code']
    if location.present? && location != ',RD' && location != ','
        @user_details = UserDetail.where('listing_type = ?', false).near(location, 15000)
      else
        @user_details = UserDetail.where('listing_type = ?', false)
    end
  end

  def change_locale
    session[:locale] = params[:locale]
    redirect_to :back
  end
  
  def page_not_found
    
  end
end
