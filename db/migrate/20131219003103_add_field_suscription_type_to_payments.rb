class AddFieldSuscriptionTypeToPayments < ActiveRecord::Migration
  def change
    add_column :paypal_payments, :subscription_type, :string
  end
end
