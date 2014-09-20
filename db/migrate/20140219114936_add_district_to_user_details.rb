class AddDistrictToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :district, :varchar
  end
end
