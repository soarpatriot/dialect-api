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

ActiveRecord::Schema.define(version: 20140813075710) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "auth_tokens", force: true do |t|
    t.string   "value"
    t.integer  "user_id"
    t.datetime "expire_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "captchas", force: true do |t|
    t.string   "mobile_number"
    t.string   "code"
    t.integer  "ctype"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chats", force: true do |t|
    t.integer  "last_sender_id"
    t.string   "last_message"
    t.datetime "last_sync_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ctype"
    t.string   "last_sender_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.integer  "information_id"
    t.integer  "target_id"
    t.string   "target_type"
  end

  create_table "checkin_histories", force: true do |t|
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "merchant_id"
  end

  create_table "ckeditor_assets", force: true do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], name: "idx_ckeditor_assetable", using: :btree
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_ckeditor_assetable_type", using: :btree

  create_table "clauses", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "content"
    t.integer  "scrip_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address"
    t.integer  "place_id"
  end

  create_table "content_addresses", force: true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_sources", force: true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "code"
    t.integer  "page",       default: 1
  end

  create_table "coupon_terms", force: true do |t|
    t.string   "term_id"
    t.string   "integer"
    t.string   "coupon_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupon_usage_histories", force: true do |t|
    t.integer  "coupon_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  add_index "coupon_usage_histories", ["coupon_id"], name: "index_coupon_usage_histories_on_coupon_id", using: :btree
  add_index "coupon_usage_histories", ["user_id"], name: "index_coupon_usage_histories_on_user_id", using: :btree

  create_table "coupons", force: true do |t|
    t.float    "amount"
    t.datetime "expire_at",   default: '2014-07-13 02:08:22'
    t.integer  "merchant_id"
    t.integer  "user_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.string   "image"
    t.integer  "count",       default: 0
  end

  create_table "devices", force: true do |t|
    t.string   "platform"
    t.string   "token"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status"
  end

  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "error_codes", force: true do |t|
    t.integer  "code"
    t.string   "summary"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "favorite_places", force: true do |t|
    t.integer  "place_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "favorite_places", ["place_id"], name: "index_favorite_places_on_place_id", using: :btree
  add_index "favorite_places", ["user_id"], name: "index_favorite_places_on_user_id", using: :btree

  create_table "favorites", force: true do |t|
    t.integer  "information_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.integer  "user_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendship_requests", force: true do |t|
    t.integer  "user_id"
    t.integer  "target_user_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "information", force: true do |t|
    t.string   "infoable_type"
    t.integer  "infoable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_destroyed",   default: false
    t.integer  "shares_count",   default: 0
    t.integer  "votes_count",    default: 0
    t.integer  "comments_count", default: 0
    t.integer  "visits_count",   default: 0
    t.integer  "place_id"
    t.integer  "subject_id"
  end

  add_index "information", ["comments_count"], name: "index_information_on_comments_count", using: :btree
  add_index "information", ["shares_count"], name: "index_information_on_shares_count", using: :btree
  add_index "information", ["visits_count"], name: "index_information_on_visits_count", using: :btree
  add_index "information", ["votes_count"], name: "index_information_on_votes_count", using: :btree

  create_table "information_share_records", force: true do |t|
    t.integer  "information_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "information_visit_records", force: true do |t|
    t.integer  "information_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "information_visit_records", ["information_id"], name: "index_information_visit_records_on_information_id", using: :btree
  add_index "information_visit_records", ["user_id"], name: "index_information_visit_records_on_user_id", using: :btree

  create_table "merchants", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo"
    t.string   "name"
    t.string   "address"
    t.integer  "parent_id"
    t.float    "longitude"
    t.float    "latitude"
  end

  add_index "merchants", ["email"], name: "index_merchants_on_email", unique: true, using: :btree
  add_index "merchants", ["reset_password_token"], name: "index_merchants_on_reset_password_token", unique: true, using: :btree

  create_table "mq100s", force: true do |t|
    t.string   "service_code"
    t.string   "number"
    t.integer  "merchant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "model"
  end

  create_table "place_user_relations", force: true do |t|
    t.integer  "place_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "place_user_relations", ["place_id"], name: "index_place_user_relations_on_place_id", using: :btree
  add_index "place_user_relations", ["user_id"], name: "index_place_user_relations_on_user_id", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
    t.string   "province"
    t.string   "city"
    t.string   "street"
    t.string   "street_number"
    t.string   "district"
    t.string   "ptype"
    t.string   "addr"
    t.integer  "user_id"
  end

  create_table "reports", force: true do |t|
    t.integer  "user_id"
    t.integer  "information_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rpush_apps", force: true do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: true do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "app"
  end

  add_index "rpush_feedback", ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree

  create_table "rpush_notifications", force: true do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                              default: "default"
    t.string   "alert"
    t.text     "data"
    t.integer  "expiry",                             default: 86400
    t.boolean  "delivered",                          default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                             default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "alert_is_json",                      default: false
    t.string   "type",                                                   null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",                   default: false,     null: false
    t.text     "registration_ids",  limit: 16777215
    t.integer  "app_id",                                                 null: false
    t.integer  "retries",                            default: 0
    t.string   "uri"
    t.datetime "fail_after"
  end

  add_index "rpush_notifications", ["app_id", "delivered", "failed", "deliver_after"], name: "index_rapns_notifications_multi", using: :btree

  create_table "scrips", force: true do |t|
    t.text     "content"
    t.string   "image"
    t.float    "longitude"
    t.float    "latitude"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.string   "title"
    t.string   "country"
    t.string   "province"
    t.string   "city"
    t.string   "district"
    t.string   "street"
    t.string   "username"
    t.boolean  "is_destroyed", default: false
    t.string   "from"
  end

  create_table "soundink_codes", force: true do |t|
    t.string   "service_code"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "soundink_codes", ["user_id"], name: "index_soundink_codes_on_user_id", using: :btree

  create_table "sponsors", force: true do |t|
    t.string   "title"
    t.string   "logo"
    t.integer  "scrip_id"
    t.boolean  "always_show"
    t.datetime "start_at"
    t.datetime "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.string   "image"
    t.string   "description"
    t.string   "owner_type"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "terms", force: true do |t|
    t.string   "category"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
  end

  create_table "users", force: true do |t|
    t.string   "mobile_number"
    t.string   "password_digest"
    t.string   "nickname"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_code"
    t.integer  "gender",          default: 0
    t.integer  "group",           default: 0
    t.string   "connection_id"
  end

  create_table "votes", force: true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree

end
