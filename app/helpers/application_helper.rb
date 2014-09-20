module ApplicationHelper
  def get_fb_app_id
    host_with_port = YAML::load(File.open("#{Rails.root.to_s}/config/facebooker.yml"))
    app_id = host_with_port[Rails.env.to_s]
  end

  def facebook_meta_title_content
    str = if params["controller"]=="tutors" && params["action"]=="show"
            "#{@tutor.subjects.first} Tutor #{@tutor.user_detail.city}, #{@tutor.user_detail.country}"
          else
            "Sou Fudao"
          end
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def average_rating(tutor_id)
    @tutor = User.find(tutor_id)
    sum_rate = 0
    avg = 0
    if @tutor.tutor_review.present?
      @tutor.tutor_review.each do |review_obj|
        sum_rate = sum_rate + review_obj.rate
      end
      avg = (sum_rate / @tutor.tutor_review.count).to_i if (@tutor.tutor_review.count != 0)
    end
    avg
  end

  def sum_rating(tutor_id)
    @tutor = User.find(tutor_id)
    sum_rate = 0
    if @tutor.tutor_review.present?
      @tutor.tutor_review.each do |review_obj|
        sum_rate = sum_rate + review_obj.rate
      end
    end
    sum_rate
  end

  def get_rating_class(rate)
    [-1, -2].include?(rate) ? "no_star" : rate
  end

  def show_lang_ability(rate)
    if (rate == 1)
      "Some"
    elsif (rate == 2)
      "Good"
    elsif (rate == 3)
      "Very_Good"
    elsif (rate == 4)
      "Fluent"
    else
      "Not Specified"
    end
  end

  def get_msg_sender(msg)
    (msg.student_id == current_user.id) ? "You" : User.find(msg.student_id).first_name
  end

  def get_sender_image_for_msgs(sender_id)
    usr = User.find(sender_id)
    usr.user_detail.blank? ? "/assets/unknown_thumb.gif" : (usr.user_detail.avatar.blank? ? "/assets/unknown_thumb.gif" : usr.user_detail.avatar.url(:thumb))
  end

  def active_link(page)
    if page == 'sign_in'
      if params[:controller] == 'devise/sessions'
        return 'active_link'
      end
    elsif page == 'sign_up'
      if params[:controller] == 'devise/registrations'
        return 'active_link'
      end
    elsif page == 'home'
       if params[:controller] == 'home'
          return 'active_link'
       end
    elsif params[:action] == page
      return 'active_link'
    elsif page == 'my_account'
      if ["my_account", "my_messages", "upgrade", "settings"].include?(params[:action])
        return 'active_link'
      end
    end
  end

end
