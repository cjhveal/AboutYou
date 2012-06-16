class CreateEducations < ActiveRecord::Migration
  def change
    create_table :educations do |t|
      t.string :name
      t.string :fbid
      t.string :school_type
      t.string :year
      t.string :concentration
      t.integer :user_id

      t.timestamps
    end
  end
end
