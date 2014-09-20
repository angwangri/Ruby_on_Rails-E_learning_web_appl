# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140712172044) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: true do |t|
    t.float    "price"
    t.string   "currency"
    t.text     "time"
    t.text     "distance"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_first_session_free", default: false
    t.text     "two_students"
    t.text     "three_plus_students"
  end

  create_table "paypal_payments", force: true do |t|
    t.integer  "user_id"
    t.string   "payer_id"
    t.string   "token"
    t.string   "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subscription_type"
    t.string   "profile_status"
    t.date     "start_date"
  end

  create_table "simple_captcha_data", force: true do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "user_id"
    t.string   "yapi_tid"
    t.string   "tid"
    t.float    "item_price"
    t.string   "item_currency"
    t.string   "subscription_type"
    t.string   "result_status"
    t.string   "result_desc"
    t.datetime "start_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "table_messages", force: true do |t|
    t.integer "user_id"
    t.string  "sender_name"
    t.string  "sender_phone"
    t.string  "sender_email"
    t.text    "message"
  end

  create_table "tutor_reviews", force: true do |t|
    t.integer  "user_id"
    t.integer  "rate"
    t.text     "review"
    t.integer  "rater_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_contact_infos", force: true do |t|
    t.string   "phone"
    t.string   "we_chat_id"
    t.string   "qq_chat_id"
    t.string   "skype_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_details", force: true do |t|
    t.integer  "user_id"
    t.boolean  "is_profile_complete?"
    t.boolean  "is_visible?"
    t.string   "street_add"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip_code"
    t.string   "gender"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "subject"
    t.text     "education"
    t.text     "experience"
    t.text     "hobbies"
    t.boolean  "is_plan_selected?",                default: false
    t.integer  "invite_counter"
    t.boolean  "listing_type",                     default: true
    t.float    "latitude"
    t.float    "longitude"
    t.string   "district",             limit: nil
    t.date     "age"
  end

  create_table "user_languages", force: true do |t|
    t.text     "lang_spoken"
    t.integer  "english_rate"
    t.integer  "chinese_rate"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nationality"
  end

  create_table "user_messages", force: true do |t|
    t.integer  "user_id"
    t.string   "sender_name"
    t.string   "sender_email"
    t.string   "sender_phone"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "student_id"
    t.boolean  "read_msg",     default: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "is_tutor?",              default: true
    t.boolean  "email_updates",          default: true
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
