class UserMailer < ActionMailer::Base
  default from: "SouFudao<admin@soufudao.com>"
  ADMIN_EMAIL = "soufudao@outlook.com"
  LOGO_URL = "#{ActionMailer::Base.default_url_options[:host]}/assets/soufudao2.png"


  def send_tutor_a_message(user_message, host)
    @user = user_message.user
    @user_message  = user_message
    @host = host
    @logo_url = LOGO_URL
    mail(to: @user.email, subject: '有学生联系您/A Student Has Contacted You: '+@user_message.sender_name)
  end

  def send_invitation_to_friend(user_details,invitee_email,host)
  	@user_detail = user_details  	
  	@host = host
    @logo_url = LOGO_URL
  	mail(to: invitee_email, subject: '看下这个网站/Check out this website')
  end  

  def send_feedback_to_admin(email,msg,name)
    @email = email
    @message = msg
    @name = name
    @logo_url = LOGO_URL
    mail(to: ADMIN_EMAIL, subject: 'Feedback from User')
  end

  def account_mail_to_student(student_user, student_user_pass, tutor_user, host)
    @host = host
    @student_user = student_user
    @student_user_pass = student_user_pass
    @tutor_user = tutor_user
    @logo_url = LOGO_URL
    mail(to: @student_user.email, subject: '搜辅导欢迎您/Welcome to Sou Fudao!')
  end

  def invite_to_student_friend(email, subject, msg_body, sender)
    @msg_body = msg_body
    @user = sender
    @logo_url = LOGO_URL
    mail(to: email, subject: "您可能会喜欢这个网站/You might like this website!")
  end

  def review_mail_to_tutor(review, host)
    @host = host
    @tutor = review.user
    @student = User.find(review.rater_id)
    @logo_url = LOGO_URL
    mail(to: @tutor.email, subject: '有新的学生评价/Review from student')
  end

  def send_student_a_message(user_message, host)
    @student = user_message.user
    @user_message  = user_message
    @host = host
    @tutor = User.find(user_message.student_id)
    @logo_url = LOGO_URL
    mail(to: @student.email, subject: '有老师回复您/A Tutor Has Contacted You: '+ @tutor.first_name)
  end
end