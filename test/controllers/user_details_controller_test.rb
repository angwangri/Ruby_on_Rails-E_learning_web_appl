require 'test_helper'

class UserDetailsControllerTest < ActionController::TestCase
  setup do
    @user_detail = user_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_detail" do
    assert_difference('UserDetail.count') do
      post :create, user_detail: { city: @user_detail.city, country: @user_detail.country, gender: @user_detail.gender, is_profile_complete?: @user_detail.is_profile_complete?, is_visible?: @user_detail.is_visible?, state: @user_detail.state, street_add: @user_detail.street_add, user_id: @user_detail.user_id, zip_code: @user_detail.zip_code }
    end

    assert_redirected_to user_detail_path(assigns(:user_detail))
  end

  test "should show user_detail" do
    get :show, id: @user_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_detail
    assert_response :success
  end

  test "should update user_detail" do
    patch :update, id: @user_detail, user_detail: { city: @user_detail.city, country: @user_detail.country, gender: @user_detail.gender, is_profile_complete?: @user_detail.is_profile_complete?, is_visible?: @user_detail.is_visible?, state: @user_detail.state, street_add: @user_detail.street_add, user_id: @user_detail.user_id, zip_code: @user_detail.zip_code }
    assert_redirected_to user_detail_path(assigns(:user_detail))
  end

  test "should destroy user_detail" do
    assert_difference('UserDetail.count', -1) do
      delete :destroy, id: @user_detail
    end

    assert_redirected_to user_details_path
  end
end
