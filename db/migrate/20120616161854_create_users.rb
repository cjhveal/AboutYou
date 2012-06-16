class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :auth_token
      t.string :email
      t.string :website
      t.string :name
      t.string :uid
      t.datetime :date_of_birth

      t.timestamps
    end
  end
end
