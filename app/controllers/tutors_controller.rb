#!/bin/env: ruby
#encoding: utf-8

class TutorsController < ApplicationController
  
	
	#before_filter :check_login_profile_done, :only => [:my_client]
	protect_from_forgery :except => [:search]
	before_action :authenticate_user!, only: [:my_client,:upgrade, :settings, :my_messages, :student_messages]
	before_action :check_if_tutor_profile_completed, only: [:show]
	

	def show
		@tutor = User.find(params[:id])
		@hash = Gmaps4rails.build_markers([@tutor]) do |t, marker|
		  marker.lat t.user_detail.latitude
		  marker.lng t.user_detail.longitude
		  # marker.infowindow user_detail.experience
	      marker.picture({
	      "url" => "/assets/blue_pointer.png",
	      "width" =>  32,
	      "height" => 32})
		end
	end

	def my_client
		@user_detail = UserDetail.find(params[:id])	
		@tutor_messages = UserMessage.all.where(:user_id => @user_detail.user_id).order("created_at DESC").page(params[:page]).per(5)
	end

	def save_tutor_message
		if simple_captcha_valid?
			session[:msg] = params[:user_messages]
			check_user_exists = User.exists?(:email => params[:user_messages][:sender_email])
			@exist_user	= User.where(:email => params[:user_messages][:sender_email])[0] if check_user_exists		
			if (user_signed_in?)
				if (current_user.is_tutor?) #if current_user = tutor
					flash[:notice] = (session[:locale] != 'cn') ? "Sorry, tutors can't contact other tutors through this website." : "对不起，老师不能通过此网页互相联系。"
				else (!current_user.is_tutor?) #if current_user = student
					is_student_created = [true, @exist_user.id]
					send_msg(params[:user_messages], is_student_created)
				end
			else
				if (check_user_exists)
					if (@exist_user.is_tutor?) #if msg_sender = tutor
						flash[:notice] = (session[:locale] != 'cn') ? "Sorry, tutors can't contact other tutors through this website." : "对不起，老师不能通过此网页互相联系。"
					else
						flash[:show_sign_in] = true
					end
				else
					flash[:show_sign_up] = true
				end
			end	
		else
			flash[:captcha_err] = (session[:locale] != 'cn') ? "Please type in the correct verification letters." : "请输入正确的验证码。"
		end
	end

	def send_msg(usr_msgs,created_student_flag)
		@user_message = UserMessage.new(usr_msgs)
		if (created_student_flag[0] && @user_message.save)
			@user_message.update(:student_id => created_student_flag[1])
			UserMailer.send_tutor_a_message(@user_message, request.host_with_port).deliver
			flash[:notice] = (session[:locale] != "cn") ? "Thank you, your message has been sent! Feel free to contact other tutors while you wait. Most tutors respond within 48 hours."
      : "谢谢，您的信息已发出！您可以继续和其他老师联系。大部分老师会在48小时内会联系您"
		else
			flash[:error] = (session[:locale] != "cn") ? "Please try again." : "请再试一次。"
		end
	end

	def create_student_user
		@student_user = User.new(:first_name=> params[:users][:first_name], :email => params[:users][:email], :password => params[:users][:password], :is_tutor? => false)
		@student_user.skip_confirmation!
			if @student_user.save	
				@tutor_user = User.find(session[:msg][:user_id])
				UserMailer.account_mail_to_student(@student_user, params[:users][:password], @tutor_user, request.host_with_port).deliver			
				send_msg(session[:msg], [true, @student_user.id])
			else
				send_msg(session[:msg], [false, @student_user.id])
			end
	end

	def send_saved_message
		if session[:msg]
			@user_message = UserMessage.new(session[:msg])
			@user_message.update(:student_id => current_user.id)
			UserMailer.send_tutor_a_message(@user_message, request.host_with_port).deliver
			flash[:notice] = (session[:locale] != "cn") ? "Thank you, your message has been sent! Feel free to contact other tutors while you wait. Most tutors respond within 48 hours."
      : "谢谢，您的信息已发出！您可以继续联系其他老师，大部分老师会在48小时内回复您。"
	    end
	    render :json => {:status => 'ok'}
	end

	def settings
		@user_detail = UserDetail.find(params[:id])	
	end
	
	def close_account
		@user_detail = UserDetail.find(params[:id])
	end

	def upgrade
		@user_detail = UserDetail.find(params[:id])
	end

	def confirm_close_account
		@user = UserDetail.find(params[:id]).user
		if @user.destroy
			 sign_out @user
			 redirect_to :action => "account_closed_message"
		else
      flash[:error] = (session[:locale] != "cn") ? "Please try again." : "请再试一次。"
			redirect_to :back
		end	
	end

	def student_close_account
		@user = User.find(params[:id])
	end

	def student_confirm_close_account
		@user = User.find(params[:id])
		if @user.destroy
			 sign_out @user
			 redirect_to :action => "account_closed_message"
		else
      flash[:error] = (session[:locale] != "cn") ? "Please try again." : "请再试一次。"
			redirect_to :back
		end	
	end	

	def account_closed_message
	end
	#This method is used to check if user is logged in and profile completed then only access /tutors/:id
	def check_login_profile_done
		unless (user_signed_in? && current_user.user_detail.is_user_profile_done?)
			redirect_to root_path
		end	
	end

	def search
	      city_states = YAML.load_file('config/city_states.yml')
	      @cities = city_states['china'].keys
	      @districts = params[:city] ? city_states['china']["#{params[:city]}"] : city_states['china']['Shanghai']
		if params[:subject].present?
			if params[:subject] == 'Any subject'
				@user_details = UserDetail.all.order('listing_type ASC')
			else
				@user_details = UserDetail.where('LOWER(subject) like (?)', "%#{params[:subject].downcase}%").order('listing_type ASC')
			end		
		else
			@user_details = UserDetail.all.order('listing_type ASC')
		end	
		if !@user_details.nil? && params[:city].present?
				@user_details = @user_details.near(params[:city], 40).order('listing_type ASC')  
		end
		@user_details = @user_details.select { |r| r.will_profile_visible? }
		#@user_details = @user_details.order('availabilities.price') if params[:sort] == 'price'
		if params[:sort] == 'price'
			@user_details = @user_details.sort{|a,b| a.user.availability.price <=> b.user.availability.price } 
			@user_details = @user_details = @user_details.sort_by { |a| a.listing_type ? 1 : 0 }
		end	
		if params[:sort] == 'rating'
			@user_details = @user_details.sort{|a,b| b.average_rating <=> a.average_rating } 
			@user_details = @user_details.sort_by { |a| a.listing_type ? 1 : 0}
		end		
		unless @user_details.kind_of?(Array)		
		  @user_details = @user_details.page(params[:page]).per(10)
		else
		  @user_details = Kaminari.paginate_array(@user_details).page(params[:page]).per(10)
		end
		
		pointer = ('A'..'J').to_a 
		i = 0
		@hash = Gmaps4rails.build_markers(@user_details) do |user_detail, marker|
		  marker.lat user_detail.latitude
		  marker.lng user_detail.longitude
		  # marker.infowindow user_detail.experience
	      marker.picture({
	      "url" => "/assets/blue_pointer.png",
	      "width" =>  25,
	      "height" => 40})
	      marker.infowindow render_to_string(:partial => "/tutors/map_pop", :locals => { :user_detail => user_detail})
	      i+=1
		end
		if request.xhr?
		    respond_to do |format|
		      format.js
		      format.html
		    end
		end
	end

	def search_list_view
	      city_states = YAML.load_file('config/city_states.yml')
	      @cities = city_states['china'].keys
	      @districts = params[:city] ? city_states['china']["#{params[:city]}"] : city_states['china']['Shanghai']

		if params[:subject].present?
			if params[:subject] == 'Any subject'
				@user_details = UserDetail.all.order('listing_type ASC')
			else
				@user_details = UserDetail.where('LOWER(subject) like (?)', "%#{params[:subject].downcase}%").order('listing_type ASC')
			end		
		else
			@user_details = UserDetail.all.order('listing_type ASC')
		end	
		if !@user_details.nil? && params[:city].present?
				@user_details = @user_details.near(params[:city], 40) 
		end
		#@user_details = @user_details.order('availabilities.price').reverse_order if params[:sort] == 'price'
		@user_details = @user_details.select { |r| r.will_profile_visible? }
		if params[:sort] == 'price'
			@user_details = @user_details.sort{|a,b| a.user.availability.price <=> b.user.availability.price } 
			@user_details = @user_details = @user_details.sort_by { |a| a.listing_type ? 1 : 0 }
		end	
		if params[:sort] == 'rating'
			@user_details = @user_details.sort{|a,b| b.average_rating <=> a.average_rating } 
			@user_details = @user_details = @user_details.sort_by { |a| a.listing_type ? 1 : 0 }
		end
		unless @user_details.kind_of?(Array)
		  @user_details = @user_details.page(params[:page]).per(10)
		else
		  @user_details = Kaminari.paginate_array(@user_details).page(params[:page]).per(10)
		end
		
	end

	def student
		@user = User.find(params[:id])
		@msgs = UserMessage.select("max(id) as id").where("student_id=#{@user.id}").group("user_id").order("id DESC")		
	end

	def student_setting
		@user = User.find(params[:id])		
	end

	def invite_students_friend
		@user = User.find(params[:id])				
	end

	def update_student_data
		@user = User.find(params[:id])
		if @user.update(:email => params[:tutors][:email], :first_name => params[:tutors][:first_name])
			flash[:notice] = (session[:locale] != "cn") ? "Updated successfully" : "更新成功"
		else
      flash[:error] = (session[:locale] != "cn") ? "Please try again." : "请再试一次。"
		end
		redirect_to :back
	end

	def tell_a_friend
		@user = User.find(params[:id])
		if UserMailer.invite_to_student_friend(params[:email], params[:subject], params[:message], @user).deliver
			flash[:notice] = (session[:locale] != "cn") ? "Your message has been sent. Thank you!\n
      To send another simply type another email address." : "您的信息已发出了。"
		else
			flash[:error] = (session[:locale] != "cn") ? "Sorry, the message could not be sent. Please try again." : "对不起，邮件未发出。请再试一次。"
		end
		redirect_to :back
	end

	def save_rate_reviews
		@user_review = TutorReview.new(params[:tutor_review])
		if @user_review.save
			UserMailer.review_mail_to_tutor(@user_review, request.host_with_port).deliver			
			flash[:notice] = (session[:locale] != "cn") ? "Rating posted successfully" : "评价成功"
		else
			flash[:error] = (session[:locale] != "cn") ? "Sorry, the rating wasn't able to post. Please try again." : "对不起，评价未成功。请再试一次。"
		end
		redirect_to :back
	end

	def reload_capcha
		respond_to do |format|
			format.js
		end
	end

	def check_if_profile_visible_to_public
		profile_user = User.find(params[:id])
		if (current_user && current_user.id == profile_user.id && !profile_user.user_detail.is_visible?)
			flash[:notice] = (session[:locale] != "cn") ? "Note: This is a preview only. You're profile can't be seen by others until you set it to public."
          : "如需大家可以看您的资料，请设置对外开放。"
		elsif (!profile_user.user_detail.is_visible?)
			redirect_to :controller => "home", :action => "search_tutors"
		end
	end

	def check_if_tutor_profile_completed		
		tutor_prof = User.find(params[:id])
		if tutor_prof.user_detail.is_user_profile_done?
			check_if_profile_visible_to_public
		else
			tutor_prof.user_detail.update("is_visible?" => false)
			check_if_profile_visible_to_public
		end	
	end

	def student_sign_in
		user = current_user
	end

	def my_messages
		@user_detail = UserDetail.find(params[:id])
		@msgs = UserMessage.select("max(id) as id").where("user_id=#{@user_detail.user_id}").group("student_id").order("id DESC")
	end

	def student_messages
		@user = User.find(params[:id])
		@msgs = UserMessage.select("max(id) as id").where("user_id=#{@user.id}").group("student_id").order("id DESC")
	end

	def show_msg_conversation
		@user_detail = current_user.user_detail
		@all_msgs = UserMessage.where("(user_id = #{params[:other_user_id]} AND student_id= #{@user_detail.user_id}) OR (student_id = #{params[:other_user_id]} AND user_id= #{@user_detail.user_id} )").order("created_at DESC")
		respond_to do |format|
			format.js
		end
	end

	def show_msg_conversation_for_student
		@user = current_user
		@all_msgs = UserMessage.where("(user_id = #{params[:other_user_id]} AND student_id= #{@user.id}) OR (student_id = #{params[:other_user_id]} AND user_id= #{@user.id} )").order("created_at DESC")
		respond_to do |format|
			format.js
		end
	end

	def send_message_via_ajax
		@user_message = UserMessage.new(params[:user_messages])
		if @user_message.save
			UserMailer.send_student_a_message(@user_message, request.host_with_port).deliver if !@user_message.user.is_tutor?
			UserMailer.send_tutor_a_message(@user_message, request.host_with_port).deliver if @user_message.user.is_tutor?
			flash[:success] = (session[:locale] != "cn") ? "Message posted successfully.".html_safe : "您的信息已发出了。".html_safe
		else
      flash[:error] = (session[:locale] != "cn") ? "Sorry, the message could not be sent. Please try again." : "对不起，邮件未发出。请再试一次。"
		end
	end
end
