#!/bin/env ruby
# encoding: utf-8
class UserDetailsController < ApplicationController
  before_action :set_user_detail, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:my_account,:profile_completion_step2,:profile_completion_step3]

  # GET /user_details
  # GET /user_details.json
  def index
    @user_details = UserDetail.all
  end

  # GET /user_details/1
  # GET /user_details/1.json
  def show
  end

  # GET /user_details/new
  def new
    @user_detail = UserDetail.new
  end

  # GET /user_details/1/edit
  def edit
  end

  # POST /user_details
  # POST /user_details.json
  def create
    @user_detail = UserDetail.new(user_detail_params)

    respond_to do |format|
      if @user_detail.save
        format.html { redirect_to @user_detail, flash[:notice] = (session[:locale] != "cn") ? 'User details successfully created.' : '保存成功' }
        format.json { render action: 'show', status: :created, location: @user_detail }
      else
        format.html { render action: 'new' }
        format.json { render json: @user_detail.errors, status: :unprocessable_entity }
      end
    end
  end

def save_user_avatar
    @user_detail = set_user_detail
    @user_avatar = params[:user_detail][:avatar] if params[:user_detail][:avatar]
    if @user_detail.update(:avatar => @user_avatar)
      flash[:notice] = (session[:locale] != "cn") ? "Photo updated successfully" : '保存成功'
    else
      flash[:notice] = (session[:locale] != "cn") ? "Error uploading photo. Please try again." : "出错了，请再试一次。"
    end 
    redirect_to :back
end

def remove_user_avatar
      @user_detail = set_user_detail
      @user_detail.avatar = nil
      @user_detail.save
      flash[:notice] = (session[:locale] != "cn") ? "Photo has been removed" : "照片已删除"
      redirect_to :back
end

def update_user_subjects
  @user_detail = set_user_detail
  if @user_detail.update(:subject => params[:user_details][:subject])
    flash[:notice] = (session[:locale] != "cn") ? "Subjects saved successfully" : "保存成功"
  else  
    flash[:error] = (session[:locale] != "cn") ? "Sorry, Subjects could not be saved. Please try again." : "出错了，请再试一次。"
  end
  @subject_status, @profile_status = @user_detail.is_subject_info_complete?, @user_detail.is_user_profile_done?
  respond_to do |format|
    format.js 
  end
end

def update_user_info
  @user_detail = set_user_detail
  @user_lang_params = params[:user_language].merge("user_id"=> @user_detail.user_id)
  if @user_detail.update(:education => params[:user_details][:education], :experience => params[:user_details][:experience], :hobbies => params[:user_details][:hobbies])
      if @user_detail.user.user_language.blank? 
        @user_lang = UserLanguage.new(@user_lang_params) unless params[:user_language].blank?
        @user_lang.save
      else
        @user_lang = @user_detail.user.user_language
        @user_lang.update(:english_rate => @user_lang_params[:english_rate], :chinese_rate => @user_lang_params[:chinese_rate], :lang_spoken => @user_lang_params[:lang_spoken])
      end
      flash[:notice] = (session[:locale] != "cn") ? "About You saved successfully" : "保存成功"
  else
      flash[:error] = (session[:locale] != "cn") ? "Sorry, About You information could not be saved. Please try again." : "出错了，请再试一次。"
  end 
    @about_you_status, @profile_status = @user_detail.is_about_you_info_complete?, @user_detail.is_user_profile_done?
    respond_to do |format|
    format.js 
  end
end

def update_phone_info
    @user_detail = set_user_detail
    @info = params[:user_contact_info]
    @contact_info = UserContactInfo.find_by_user_id(@user_detail.user_id)
    if @contact_info 
      @contact_info.update(:phone => @info[:phone], :qq_chat_id => @info[:qq_chat_id], :we_chat_id => @info[:we_chat_id], :skype_id => @info[:skype_id])
    else
      @contact_info = UserContactInfo.new(@info)
      @contact_info.save
    end  
    flash[:notice] = (session[:locale] != "cn") ? "Contact Information saved successfully" : "保存成功"
    @phone_status, @profile_status = @user_detail.is_phone_chat_info_complete?, @user_detail.is_user_profile_done?
    respond_to do |format|
    format.js 
  end
end

def profile_completion_step3
  @user_detail = UserDetail.find_by_user_id(current_user.id)
  @user_detail.update(:is_profile_complete? => true)
end

  # PATCH/PUT /user_details/1
  # PATCH/PUT /user_details/1.json
  def update
    respond_to do |format|
      if @user_detail.update(user_detail_params)
        format.html { redirect_to @user_detail, notice: 'Details successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user_detail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_details/1
  # DELETE /user_details/1.json
  def destroy
    @user_detail.destroy
    respond_to do |format|
      format.html { redirect_to user_details_url }
      format.json { head :no_content }
    end
  end

  def update_password
    unless current_user.nil?
      @user = current_user
      @current_user_detail = UserDetail.find_by_user_id(@user.id)
    else
      flash[:notice] = (session[:locale] != "cn") ? "Sorry, you are not logged in. Please log in and try again." : "请先登陆。"
    end
  end

  def profile_completion_step2
      city_states = YAML.load_file('config/city_states.yml')
      @cities = city_states['china'].keys
      @districts = city_states['china']['Shanghai']

    @user_detail = UserDetail.find(params[:id])
    @user = User.find(@user_detail.user_id)
    @availability = @user.availability
    @available_day = Availability::TIME_DAY
    @available_time = Availability::TIME_TIME
    @availability_location = Availability::DISTANCE_LOCATION
    @availability_rate = Availability::DISTANCE_RATE    
  end

  def update_user_details
      @user_detail = UserDetail.find(params[:id])
      @user = @user_detail.user
      details = params[:user_details]
      dob = params[:user_details]["age(3i)"]+"-"+params[:user_details]["age(2i)"]+"-"+params[:user_details]["age(1i)"] unless (params[:user_details]["age(3i)"].blank? ||  params[:user_details]["age(2i)"].blank? || params[:user_details]["age(1i)"].blank?)
      @user_lang_params = params[:user_language].merge("user_id" => @user_detail.user_id) unless params[:user_language].blank?      
          #if @user_detail.update(:street_add => details[:street_add], :city => details[:city], :state => details[:state], 
          #                   :country => details[:country], :zip_code => details[:zip_code], :gender => details[:gender]) && @user.update(:first_name => details[:first_name], :last_name => details[:last_name], :email => details[:email])
          if (@user_detail.update(:gender => details[:gender]) && @user.update(:first_name => details[:first_name], :last_name => details[:last_name], :email => details[:email]))
               @user_detail.update(:age => dob.to_date) unless dob.blank?            
            if @user.user_language.blank? 
              @user_lang = UserLanguage.new(@user_lang_params) unless params[:user_language].blank?
              @user_lang.save
            else
              @user_lang = @user.user_language
              @user_lang.update(:nationality => @user_lang_params[:nationality])
            end 
            flash[:notice] = (session[:locale] != "cn") ? 'Basic Info saved successfully.' : "保存成功"
          else
            flash[:error] = true
          end
      @basic_info_status, @profile_status = @user_detail.is_basic_info_complete?, @user_detail.is_user_profile_done?
      respond_to do |format|
        format.js 
      end
  end

  def update_location_details
    @user_detail = UserDetail.find(params[:id])
    details = params[:user_details]
    if @user_detail.update(:street_add => details[:street_add], :city => details[:city], :state => details[:state], 
                             :country => details[:country], :zip_code => details[:zip_code], :district => details[:district]) 
      flash[:notice] = (session[:locale] != "cn") ? 'Location updated successfully.' : "保存成功"
    else
        flash[:error] = (session[:locale] != "cn") ? 'Sorry, Location could not be saved. Please try again.' : "粗错了，请再试一次。"
    end
    @hash = Gmaps4rails.build_markers([@user_detail]) do |t, marker|
      marker.lat t.latitude
      marker.lng t.longitude
      # marker.infowindow user_detail.experience
        marker.picture({
       "url" => "/assets/blue-dot1.png",
        "width" =>  32,
        "height" => 32})
    end
      @location_info_status, @profile_status = @user_detail.is_location_info_complete?, @user_detail.is_user_profile_done?
      respond_to do |format|
        format.js 
      end    
  end

  def update_profile_visibility
      @user_detail = UserDetail.find(params[:id])
      if params[:is_visible] && @user_detail.is_user_profile_done? 
        @user_detail.update(:is_visible? => params[:is_visible]) unless params[:is_visible].nil?
      else
        @user_detail.update(:is_visible? => false) 
        flash[:notice] = (session[:locale] != "cn") ? "Please complete your profile before setting it to public. " : "请先完成资料填写。"
      end
      redirect_to :back
  end


  def save_listing_type
    @user_detail = UserDetail.find_by_user_id(current_user.id)
    if @user_detail.update(:is_plan_selected? => true)
      redirect_to :controller => "tutors",:action => "show", :id=>@user_detail.user_id
    else
      flash[:notice] = (session[:locale] != "cn") ? "Sorry, please try again" : "请再试一次"
      redirect_to :back
    end    
  end

  def update_availability_info
      availability = Availability.find_by_user_id(current_user.id)
      availability.user_id = current_user.id
      availability.time = nil unless params[:user][:time]
      availability.distance = nil unless params[:user][:distance]
      availability.is_first_session_free = (params[:user][:is_first_session_free] == "1") ? true :false unless params[:user][:is_first_session_free]
      if availability.update(params[:user])
        flash[:notice] = (session[:locale] != "cn") ? 'Rates and Availability successfully updated' : "保存成功"
      else
        flash[:error] = (session[:locale] != "cn") ? 'Sorry, Rates and Availability could not be saved. Please try again.' : "粗错了，请再试一次。"
      end
      user_detail = UserDetail.find_by_user_id(current_user.id)
      @availability_status, @profile_status = user_detail.is_availability_info_complete?, user_detail.is_user_profile_done?
      respond_to do |format|
        format.js 
      end
  end

  def add_time_select
      @available_day = Availability::TIME_DAY
      @available_time = Availability::TIME_TIME
      respond_to do |format|
        format.js 
      end
  end

  def add_distance_select
      @availability_location = Availability::DISTANCE_LOCATION
      @availability_rate = Availability::DISTANCE_RATE
      respond_to do |format|
        format.js 
      end
  end

  def my_account
    if current_user.is_tutor?
      @user_detail = UserDetail.find_by_user_id(current_user.id) 
      @user = @user_detail.user 
      city_states = YAML.load_file('config/city_states.yml')
      @cities = city_states['china'].keys
      @districts = @user_detail.city ? city_states['china']["#{@user_detail.city}"] : city_states['china']['Shanghai']

      @hash = Gmaps4rails.build_markers([@user_detail]) do |t, marker|
      marker.lat t.latitude
      marker.lng t.longitude
      # marker.infowindow user_detail.experience
        marker.picture({
        "url" => "/assets/blue-dot1.png",
        "width" =>  32,
        "height" => 32})
      end  
    end
  end

  def get_districts
    @user_detail = UserDetail.find_by_user_id(current_user.id) if current_user
    city_states = YAML.load_file('config/city_states.yml')
    @cities = city_states['china'].keys
    @districts = city_states['china']["#{params[:city]}"]
      respond_to do |format|
        format.js 
      end
  end

  def invite_a_friend
    @user_detail = UserDetail.find(params[:id])
    @invitee_email = params[:user_details][:email] if params[:user_details][:email]
    @host = request.host_with_port
    unless @invitee_email.blank?
        UserMailer.send_invitation_to_friend(@user_detail,@invitee_email,@host).deliver
        flash[:notice] = (session[:locale] != "cn") ? "Invitation sent successfully" : "发送成功！"
    else
      flash[:error] = (session[:locale] != "cn") ? "Please provide your email address" : "请提供您邮件。"
    end  
    redirect_to :back
  end

  def email_updates_flag
    @user = User.find(params[:id])
    @user.update(:email_updates => params[:user][:email_updates])
    redirect_to :back
  end

  def add_more_degree
      respond_to do |format|
        format.js 
      end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user_detail
    @user_detail = UserDetail.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_detail_params
    params.require(:user_detail).permit(:user_id, :is_profile_complete?, :is_visible?, :street_add, :city, :state, :country, :district, :zip_code, :gender,:avatar, :subject, :education, :experience, :hobbies, :chat_id, :is_plan_selected?, :phone, :listing_type, :age, user_attributes: [:id, :first_name,:last_name,:email,:email_updates])
  end
end
