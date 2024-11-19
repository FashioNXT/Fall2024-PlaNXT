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

ActiveRecord::Schema[7.0].define(version: 2023_11_29_104030) do
  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "model"
    t.float "width"
    t.float "length"
    t.float "depth"
    t.float "rotation"
    t.string "description"
    t.float "xpos"
    t.float "ypos"
    t.float "zpos"
    t.integer "step_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "setup_start_time"
    t.datetime "setup_end_time"
    t.datetime "breakdown_start_time"
    t.datetime "breakdown_end_time"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.string "owner"
    t.float "venue_length"
    t.float "venue_width"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.string "timezone"
    t.index ["user_id"], name: "index_plans_on_user_id"
  end

  create_table "steps", force: :cascade do |t|
    t.date "start_date"
    t.integer "plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "break1_start_time"
    t.datetime "break1_end_time"
    t.datetime "break2_start_time"
    t.datetime "break2_end_time"
  end

  create_table "users", force: :cascade do |t|
    t.integer "level"
    t.string "name", null: false
    t.string "email", null: false
    t.string "password_digest"
    t.string "viewPermission"
    t.string "editPermission"
    t.text "description"
    t.string "extra1"
    t.string "extra2"
    t.string "extra3"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "items", "steps"
  add_foreign_key "plans", "users"
  add_foreign_key "steps", "plans"
end
