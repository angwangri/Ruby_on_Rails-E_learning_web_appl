class AddStudentIdToUserMessages < ActiveRecord::Migration
  def change
    add_column :user_messages, :student_id, :integer
  end
end
