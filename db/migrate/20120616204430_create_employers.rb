class CreateEmployers < ActiveRecord::Migration
  def change
    create_table :employers do |t|
      t.string :name
      t.string :location
      t.datetime :start_date
      t.datetime :end_date
      t.string :fbid

      t.timestamps
    end
  end
end
