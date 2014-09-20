class AddFieldsToUserDetails < ActiveRecord::Migration
  def change
    add_column :user_details, :phone, :string
    add_column :user_details, :chat_id, :string
    add_column :user_details, :subject, :text
    add_column :user_details, :education, :text
    add_column :user_details, :experience, :text
    add_column :user_details, :hobbies, :text
  end
end
