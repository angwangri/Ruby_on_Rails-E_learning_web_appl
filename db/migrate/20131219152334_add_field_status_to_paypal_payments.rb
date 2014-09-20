class AddFieldStatusToPaypalPayments < ActiveRecord::Migration
  def change
    add_column :paypal_payments, :profile_status, :string
    # save status "ACTIVE" when featured payment is sucessful
    # save status "CANCELLED" when featured recurring  payment is cancelled
  end
end
