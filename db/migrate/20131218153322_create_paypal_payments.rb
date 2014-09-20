class CreatePaypalPayments < ActiveRecord::Migration
  def change
    create_table :paypal_payments do |t|
      t.integer :user_id
      t.string :payer_id
      t.string :token
      t.string :profile_id

      t.timestamps
    end
  end
end
