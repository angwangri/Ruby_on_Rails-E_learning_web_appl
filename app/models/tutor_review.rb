class TutorReview < ActiveRecord::Base
	belongs_to :user
	attr_accessible :user_id, :rate, :review, :rater_id
end
