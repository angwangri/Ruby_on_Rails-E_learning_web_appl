class AddInviteCounterToUserDetails < ActiveRecord::Migration
  def change
  	add_column :user_details, :invite_counter, :integer
  end
end
