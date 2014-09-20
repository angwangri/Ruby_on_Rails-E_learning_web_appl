class AddFieldListingTypeToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :listing_type, :boolean, :default => true
    # true - free lsiting
    # false - featured listing
  end
end
