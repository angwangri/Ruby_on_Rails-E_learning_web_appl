class CreateUserContactInfos < ActiveRecord::Migration
  def change
    create_table :user_contact_infos do |t|
      t.string :phone
      t.string :we_chat_id
      t.string :qq_chat_id
      t.string :skype_id
      t.integer :user_id

      t.timestamps
    end
  end
end
