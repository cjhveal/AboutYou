class Education < ActiveRecord::Base
  attr_accessible :concentration, :fbid, :name, :school_type, :year

  has_one :user
end
