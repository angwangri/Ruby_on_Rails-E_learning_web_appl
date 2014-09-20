class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
	  t.integer :user_id
	  t.string :yapi_tid
	  t.string :tid
	  t.float :item_price
	  t.string :item_currency
	  t.string :subscription_type
	  t.string :result_status
	  t.string :result_desc 
	  t.datetime :start_date
	  t.string :status
      t.timestamps
    end
  end
end
