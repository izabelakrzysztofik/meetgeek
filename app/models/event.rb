class Event < ActiveRecord::Base
	DATE_MAPPING = {
		"Today" => :today, "All Dates" => :all, "Tomorrow" => :tomorrow, "This week" => :week
	}

  	geocoded_by :address
	after_validation :geocode, :if => :address_changed? 
end
