class AddLatitudeAndLongitudeToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :latitude, :float
    add_column :user_details, :longitude, :float
  end
end
