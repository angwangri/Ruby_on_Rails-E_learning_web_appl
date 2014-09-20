class AddColumnAgeInUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :age, :date  	
  end
end
