class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.integer :user_id
      t.string :sender_name
      t.string :sender_email
      t.string :sender_phone
      t.text :message

      t.timestamps
    end
  end
end
