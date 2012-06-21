class ChangeEducationYearToDatetime < ActiveRecord::Migration
  def up
    add_column :educations, :end_date, :datetime
    Education.all.each {|e| e.update_attribute :end_date, DateTime.parse("1-5-#{e.year}") if e.year}
    remove_column :educations, :year
  end

  def down
    add_column :educations, :year, :string
    Education.all.each {|e| e.update_attribute :year, e.end_date.year if e.end_date}
    remove_column :educations, :end_date
  end
end
