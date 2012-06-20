class AddHomeTownAndLocationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hometown, :string
    add_column :users, :location, :string
  end
end
