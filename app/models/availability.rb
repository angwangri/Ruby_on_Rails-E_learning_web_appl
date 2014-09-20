class Availability < ActiveRecord::Base

	attr_accessible :time, :distance, :price, :currency, :user_id, :two_students, :three_plus_students, :is_first_session_free
	
	belongs_to :user

	serialize :time
	serialize :distance
  serialize :one_student
  serialize :two_students
  serialize :three_plus_students     


	CURRENCY = {  "CNY" => "RMB (China Yuan Renminbi) - CNY",
                "USD" => "United States Dollars - USD",
				        "EUR" => "Euros - EUR",
                "HKD" => "Hong Kong Dollars - HKD",
                "TWD" => "Taiwan New Dollars - TWD",
             }


    TIME_DAY = {"Any day" => "Any day",
           "Weekdays" => "Weekdays",
           "Weekends" => "Weekends",
           "Monday/Wednesday/Friday" => "Monday/Wednesday/Friday",
           "Tuesday/Thursday" => "Tuesday/Thursday",
           "Sunday" => "Sunday",
           "Monday" => "Monday",
           "Tuesday" => "Tuesday",
           "Wednesday" => "Wednesday",
           "Thursday" => "Thursday",
           "Friday" => "Friday",
           "Saturday" => "Saturday"
    }

    TIME_TIME = {"at any time" => "at any time",
           "in the morning" => "in the morning",
           "in the afternoon" => "in the afternoon",
           "in the evening" => "in the evening",
           "after 9AM" => "after 9AM",
           "after 10AM" => "after 10AM",
           "after 11AM" => "after 11AM",
           "after 12PM" => "after 12PM",
           "after 1PM" => "after 1PM",
           "after 2PM" => "after 2PM",
           "after 3PM" => "after 3PM",
           "after 4PM" => "after 4PM",
           "after 5PM" => "after 5PM",
           "after 6PM" => "after 6PM",
           "after 7PM" => "after 7PM",
           "after 8PM" => "after 8PM",
           "after 9PM" => "after 9PM"
    }

    DISTANCE_LOCATION = {"Up to 30 minutes away" => "Up to 30 minutes away",
                   "Up to 15 minutes away" => "Up to 15 minutes away",                  
                   "Up to 45 minutes away" => "Up to 45 minutes away",
                   "Up to 1 hour away" => "Up to 1 hour away",
                   "Over 1 hour away" => "Over 1 hour away"
    }

    DISTANCE_RATE = {"At my regular rate" => "At my regular rate",
                   "For an additional travel fee" => "For an additional travel fee"
    }
end
