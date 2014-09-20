class UserDetail < ActiveRecord::Base
  belongs_to :user
  geocoded_by :address
  after_validation :geocode

  attr_accessible :user_id, :is_visible?, :is_profile_complete?, :gender, :street_add, :city, :country, :zip_code,
				  :state, :user_attributes, :avatar, :subject, :education, :experience, :hobbies, :is_plan_selected?, :invite_counter, :listing_type, :latitude, :longitude, :district, :age

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment :avatar, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }
  #accepts_nested_attributes_for :user

serialize :education

def address
  [street_add, city, district, country].compact.join(' ')
end

def location
  [city, country].compact.join(', ')
end

def is_basic_info_complete?
	!(self.user.first_name.blank? || self.user.last_name.blank? || self.user.email.blank? || self.gender.blank?)
end  

def is_location_info_complete?
  # !(self.city.blank? || self.state.blank? || self.country.blank?)
  !(self.city.blank? || self.district.blank? || self.country.blank?)
end

def is_subject_info_complete?
	!(self.subject.blank?)
end 

def is_about_you_info_complete?
	!(self.experience.blank? || self.hobbies.blank?)
end 

def is_availability_info_complete?
	!(self.user.availability.price.blank? || self.user.availability.distance.blank? || self.user.availability.currency.blank? || self.user.availability.time.blank? )
end

#This method is for optional photo field
def is_photo_info_complete?
	!(self.avatar.blank?)
end

#This method is for optional phone field
def is_phone_chat_info_complete?
  contact_info = UserContactInfo.find_by_user_id(self.user_id)
	!(contact_info.phone.blank? && contact_info.qq_chat_id.blank? && contact_info.we_chat_id.blank? && contact_info.skype_id.blank?) unless contact_info.nil?
end

# To check 45sections of profile step 2 if completed by user or not
def is_user_profile_done?
	(is_basic_info_complete? && is_location_info_complete? && is_subject_info_complete? && is_about_you_info_complete? && is_availability_info_complete?)
end

def is_profile_and_listing_done?
	(is_user_profile_done? && self.is_plan_selected?)
end
 
def get_user_avatar
	!(self.avatar.blank?) ? self.avatar.url(:thumb) : "/assets/no_profile_pic.gif"	      				
end

# On Profile page if any one of the section out of 4 is incomplete then set is_visible to false.
def will_profile_visible?
	(self.is_visible? && is_user_profile_done?)
end

def show_listing_type
	(self.listing_type ? "Free Listing" : "Premium Listing" )
end

def average_rating
@tutor = self.user
  sum_rate = 0
  avg = 0 
  @tutor.tutor_review.each do |review_obj|
    sum_rate = sum_rate + review_obj.rate
  end
  avg = (sum_rate / @tutor.tutor_review.count).to_i if (@tutor.tutor_review.count != 0)
  avg
end

def get_count_of_new_msgs
  UserMessages.where('user_id = ? and created_at > ?',self.user.id, self.user.last_sign_in_at).count
end
end