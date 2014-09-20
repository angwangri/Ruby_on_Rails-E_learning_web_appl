class AddColumnReadMsgToUserMessages < ActiveRecord::Migration
  def change
    add_column :user_messages, :read_msg, :boolean, :default => false
    #user_id :- receiver_id
    #student_id:- sender_id
  end
end
