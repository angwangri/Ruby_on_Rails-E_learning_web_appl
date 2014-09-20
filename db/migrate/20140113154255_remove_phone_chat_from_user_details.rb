class RemovePhoneChatFromUserDetails < ActiveRecord::Migration
  def change
    remove_column :user_details, :phone, :string
    remove_column :user_details, :chat_id, :string
  end
end
