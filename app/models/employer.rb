class Employer < ActiveRecord::Base
  attr_accessible :end_date, :fbid, :location, :name, :start_date, :position, :user_id

  has_one :user
end
