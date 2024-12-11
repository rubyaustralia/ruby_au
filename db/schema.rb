# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2020_10_10_015538) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "access_requests", force: :cascade do |t|
    t.string "name", null: false
    t.text "reason"
    t.date "requested_on", null: false
    t.date "viewed_on"
    t.bigint "recorder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recorder_id"], name: "index_access_requests_on_recorder_id"
  end

  create_table "campaign_deliveries", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "membership_id"
    t.datetime "delivered_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["campaign_id"], name: "index_campaign_deliveries_on_campaign_id"
    t.index ["membership_id"], name: "index_campaign_deliveries_on_membership_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "rsvp_event_id"
    t.string "subject", null: false
    t.string "preheader", null: false
    t.text "content"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rsvp_event_id"], name: "index_campaigns_on_rsvp_event_id"
  end

  create_table "imported_members", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "email", null: false
    t.json "data", default: {}, null: false
    t.datetime "contacted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token", null: false
    t.datetime "unsubscribed_at"
    t.index ["contacted_at"], name: "index_imported_members_on_contacted_at"
    t.index ["email"], name: "index_imported_members_on_email"
    t.index ["token"], name: "index_imported_members_on_token", unique: true
    t.index ["unsubscribed_at"], name: "index_imported_members_on_unsubscribed_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "joined_at", null: false
    t.datetime "left_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "rsvp_events", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "happens_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
  end

  create_table "rsvps", force: :cascade do |t|
    t.bigint "rsvp_event_id", null: false
    t.bigint "membership_id", null: false
    t.string "status", default: "unknown", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "proxy_name"
    t.text "proxy_signature"
    t.datetime "proxy_assigned_at"
    t.index ["membership_id"], name: "index_rsvps_on_membership_id"
    t.index ["rsvp_event_id"], name: "index_rsvps_on_rsvp_event_id"
    t.index ["token"], name: "index_rsvps_on_token", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "preferred_name"
    t.string "full_name"
    t.boolean "mailing_list", default: false, null: false
    t.boolean "visible", default: false, null: false
    t.string "encrypted_password"
    t.string "token"
    t.boolean "email_confirmed", default: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.text "address"
    t.datetime "deactivated_at"
    t.boolean "committee", default: false, null: false
    t.json "mailing_lists", default: {}, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "access_requests", "users", column: "recorder_id"
  add_foreign_key "campaign_deliveries", "campaigns"
  add_foreign_key "campaign_deliveries", "memberships"
  add_foreign_key "campaigns", "rsvp_events"
  add_foreign_key "memberships", "users"
  add_foreign_key "rsvps", "memberships"
  add_foreign_key "rsvps", "rsvp_events"
end
