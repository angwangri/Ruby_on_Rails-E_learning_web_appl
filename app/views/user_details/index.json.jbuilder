json.array!(@user_details) do |user_detail|
  json.extract! user_detail, :user_id, :is_profile_complete?, :is_visible?, :street_add, :city, :state, :country, :zip_code, :gender
  json.url user_detail_url(user_detail, format: :json)
end
