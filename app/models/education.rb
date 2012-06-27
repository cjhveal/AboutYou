class Education < ActiveRecord::Base
  attr_accessible :concentration, :fbid, :name, :school_type, :year

  has_one :user

  def start_date
    end_date - duration.years + 4.months
  end

  def duration
    return 4 if school_type.blank? or school_type == "High School"
    if school_type == "College"
      total = 3
      total += 1 if concentration =~ /honou?rs/i
      total += 1 if concentration =~ /(co\-op|coop)/i
    end
    return total
  end
end
