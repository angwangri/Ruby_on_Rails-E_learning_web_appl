class CreateTableMessages < ActiveRecord::Migration
  def change
    create_table :table_messages do |t|
      t.integer :user_id
      t.string :sender_name
      t.string :sender_phone
      t.string :sender_email
      t.text :message
    end
  end
end
