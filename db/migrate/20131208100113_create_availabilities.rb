class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.float :price
      t.string :currency		
      t.text :time
      t.text :distance
      t.integer :user_id

      t.timestamps
    end
  end
end
