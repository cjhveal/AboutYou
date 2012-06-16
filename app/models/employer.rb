class Employer < ActiveRecord::Base
  attr_accessible :end_date, :fbid, :location, :name, :start_date

  has_one :user
end
