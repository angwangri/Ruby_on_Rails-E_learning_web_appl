class AddAttachmentAvatarToUserDetails < ActiveRecord::Migration
  def self.up
    change_table :user_details do |t|
      t.attachment :avatar
    end
  end

  def self.down
    drop_attached_file :user_details, :avatar
  end
end
