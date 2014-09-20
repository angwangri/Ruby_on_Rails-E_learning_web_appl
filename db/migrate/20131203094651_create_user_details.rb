class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.integer :user_id
      t.boolean :is_profile_complete?
      t.boolean :is_visible?
      t.string :street_add
      t.string :city
      t.string :state
      t.string :country
      t.string :zip_code
      t.string :gender

      t.timestamps
    end
  end
end
