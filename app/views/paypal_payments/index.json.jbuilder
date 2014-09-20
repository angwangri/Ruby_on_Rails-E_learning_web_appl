json.array!(@paypal_payments) do |paypal_payment|
  json.extract! paypal_payment, :user_id, :payer_id, :token, :profile_id
  json.url paypal_payment_url(paypal_payment, format: :json)
end
