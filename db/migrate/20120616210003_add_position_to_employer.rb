class AddPositionToEmployer < ActiveRecord::Migration
  def change
    add_column :employers, :position, :string
  end
end
