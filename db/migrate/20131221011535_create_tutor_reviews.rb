class CreateTutorReviews < ActiveRecord::Migration
  def change
    create_table :tutor_reviews do |t|
      t.integer :user_id
      t.integer :rate
      t.text :review
      t.integer :rater_id
      t.timestamps
    end
  end
end
