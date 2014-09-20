class CreateUserLanguages < ActiveRecord::Migration
  def change
    create_table :user_languages do |t|
      t.text :lang_spoken
      t.integer :english_rate
      t.integer :chinese_rate
      t.integer :user_id

      t.timestamps
    end
  end
end
