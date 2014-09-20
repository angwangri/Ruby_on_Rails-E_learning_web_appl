class AddFieldStartDateToPaypalPayments < ActiveRecord::Migration
  def change
    add_column :paypal_payments, :start_date, :date
  end
end
