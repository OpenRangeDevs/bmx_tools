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

ActiveRecord::Schema[8.0].define(version: 2025_08_13_131013) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clubs", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "timezone", default: "Mountain Time (US & Canada)", null: false
    t.datetime "deleted_at"
    t.string "location"
    t.string "contact_email"
    t.bigint "owner_user_id"
    t.string "website_url"
    t.text "description"
    t.index ["deleted_at"], name: "index_clubs_on_deleted_at"
    t.index ["slug"], name: "index_clubs_on_slug", unique: true
  end

  create_table "ownership_transfers", force: :cascade do |t|
    t.integer "club_id", null: false
    t.integer "from_user_id", null: false
    t.string "to_user_email", null: false
    t.string "token", null: false
    t.datetime "expires_at", null: false
    t.datetime "completed_at"
    t.datetime "cancelled_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_ownership_transfers_on_club_id"
    t.index ["from_user_id"], name: "index_ownership_transfers_on_from_user_id"
    t.index ["token"], name: "index_ownership_transfers_on_token", unique: true
  end

  create_table "race_activities", force: :cascade do |t|
    t.integer "race_id"
    t.integer "club_id", null: false
    t.string "activity_type", null: false
    t.text "message", null: false
    t.json "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_type"], name: "index_race_activities_on_activity_type"
    t.index ["club_id", "created_at"], name: "index_race_activities_on_club_id_and_created_at"
    t.index ["club_id"], name: "index_race_activities_on_club_id"
    t.index ["race_id"], name: "index_race_activities_on_race_id"
  end

  create_table "race_settings", force: :cascade do |t|
    t.integer "race_id", null: false
    t.time "registration_deadline"
    t.time "race_start_time"
    t.text "notification_message"
    t.datetime "notification_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["race_id"], name: "index_race_settings_on_race_id"
  end

  create_table "races", force: :cascade do |t|
    t.integer "at_gate", default: 0, null: false
    t.integer "in_staging", default: 0, null: false
    t.integer "club_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_races_on_club_id"
  end

  create_table "tool_permissions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "tool", default: 0, null: false
    t.integer "role", null: false
    t.integer "club_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_tool_permissions_on_club_id"
    t.index ["user_id", "tool", "club_id"], name: "index_tool_permissions_on_user_id_and_tool_and_club_id", unique: true
    t.index ["user_id"], name: "index_tool_permissions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clubs", "users", column: "owner_user_id"
  add_foreign_key "ownership_transfers", "clubs"
  add_foreign_key "ownership_transfers", "users", column: "from_user_id"
  add_foreign_key "race_activities", "clubs"
  add_foreign_key "race_activities", "races"
  add_foreign_key "race_settings", "races"
  add_foreign_key "races", "clubs"
  add_foreign_key "tool_permissions", "clubs"
  add_foreign_key "tool_permissions", "users"
end
