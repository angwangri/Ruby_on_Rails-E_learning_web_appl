class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  attr_accessible :id, :email, :password, :password_confirmation, :remember_me,
    :confirmed_at, :locked_at, :first_name, :last_name, :confirmation_token, :is_tutor?, :email_updates
    
  attr_accessible :email_confirmation 

  validates :first_name, presence: true, length: { in: 1..20 }
  validates :last_name, presence: true, length: { in: 1..20 }, :if => :is_tutor?
  validates :email, uniqueness: true
  validates :password, presence: true, confirmation: true, length: { in: 6..20 }, :on => :create

  #callback starts
  after_create :create_user_details
  after_destroy :destroy_user_related_data
  #callback ends

  #association starts
  has_one :user_detail
  has_one :user_contact_info
  has_one :availability
  has_one :user_language
  has_many :user_messages
  has_many :paypal_payments
  has_many :tutor_review
  has_many :subscriptions
  #association ends

  scope :tutors, -> { where(is_tutor: true) }
  
  def if_student
    self.is_tutor? != true  
  end

  def create_user_details
    self.build_user_detail(:is_profile_complete? => FALSE, :is_visible? => true, :invite_counter => 5) 
    self.build_availability if self.is_tutor?
  end

  def destroy_user_related_data
    (self.user_detail.delete && UserMessage.delete_all(:user_id => self.id) && UserMessage.delete_all(:student_id => self.id) && self.availability.delete) if self.is_tutor?
    (UserMessage.delete_all(:user_id => self.id) && UserMessage.delete_all(:student_id => self.id) ) unless self.is_tutor?
  end

  def fullname
    "#{self.first_name} #{last_name}"
  end

  def abbreviated_name
    "#{self.first_name} #{last_name[0,1]}"
  end

  def location
    detail = self.user_detail
    "#{detail.city}, #{detail.country}"
  end

  def zip_code
    "#{self.user_detail.zip_code}"
  end

  def member_since
    self.confirmed_at.strftime("%Y/%m")
  end

  def subjects
    self.user_detail.subject ? self.user_detail.subject.split(',') : []
  end

  def rate
    self.availability.price ? "#{self.availability.price.floor} #{self.availability.currency}" : 0.00
  end

  def price 
    self.availability.price ? "#{self.availability.price.floor}" : 0.00
  end

  def currency
    self.availability.price ? "#{self.availability.currency}" : ""
  end

  def gender
    self.user_detail.gender
  end

  def education
    self.user_detail.education
  end

  def experience
    self.user_detail.experience
  end

  def hobbies
    self.user_detail.hobbies
  end

  def available_days
    str = "<ul style='padding-left:0px;margin-left:5px;'>"
    self.availability.time.each do |key_val|
      str += "<li>#{I18n.t('days.'+key_val['day'])} #{I18n.t('times.'+key_val['time'])}</li>"
      #str += "<br/>"
    end if self.availability.time
    str += "</ul>"
    str.html_safe
  end

  def available_distance
    str = "<ul style='padding-left:0px;margin-left:5px;'>"
    self.availability.distance.each do |key_val|
      str += "<li>#{I18n.t('distance_location.'+key_val['location'])} <br/> #{I18n.t('distance_rate.'+key_val['rate'])}</li>"
      #str += "<br/>"
    end if self.availability.distance
    str += "</ul>"
    str.html_safe
  end


  def available_distance_first
    if self.availability.distance
      distance = self.availability.distance.first 
      str = "#{I18n.t('distance_location.'+distance['location'])} <br/> #{I18n.t('distance_rate.'+distance['rate'])}".html_safe
    else
      str = ''
    end 
    str
  end

  def response_rate
    student_contacted = self.user_messages.select('student_id').group('student_id').length
    replied = self.user_messages.select('user_id').where('student_id = ?',id).group('user_id').length
    percent = (replied/student_contacted)*100 if student_contacted != 0 
    percent ? percent : 0 
  end

  def nationality
    self.user_language.nationality.titleize if self.user_language
  end

  def short_address
    "#{self.user_detail.city}, #{self.user_detail.state}, #{self.user_detail.country}"
  end

  def full_address
    str = ""
    str += "#{self.user_detail.street_add}," if self.user_detail.street_add.present?
    str += "#{self.user_detail.city}, #{self.user_detail.state}, #{self.user_detail.country}"
    str
  end 

  def get_count_of_new_msgs
    UserMessages.where('user_id = ? and created_at > ?',self.id, self.last_sign_in_at).count
  end

  def pending_review?

  end

  def subscription_end_date
    if (self.subscriptions.last.subscription_type == Subscription::MONTH)
      self.subscriptions.last.start_date + 1.month
    else
      self.subscriptions.last.start_date + 1.year
    end
  end
end
