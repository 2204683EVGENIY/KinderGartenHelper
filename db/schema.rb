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

ActiveRecord::Schema[8.0].define(version: 2025_01_05_172256) do
  create_table "children", force: :cascade do |t|
    t.integer "group_id", null: false
    t.string "first_name", null: false
    t.string "middle_name", null: false
    t.string "last_name", null: false
    t.integer "account_number", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_children_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "info_about_visits", force: :cascade do |t|
    t.integer "child_id", null: false
    t.date "date", null: false
    t.boolean "kindergarten_visited", null: false
    t.integer "reason", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id"], name: "index_info_about_visits_on_child_id"
  end

  create_table "mentors", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "middle_name", null: false
    t.string "last_name", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_mentors_on_group_id"
  end

  create_table "monthly_reports", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "mentor_id", null: false
    t.date "report_date", null: false
    t.json "data", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_monthly_reports_on_group_id"
    t.index ["mentor_id"], name: "index_monthly_reports_on_mentor_id"
  end

  add_foreign_key "children", "groups"
  add_foreign_key "info_about_visits", "children"
  add_foreign_key "mentors", "groups"
  add_foreign_key "monthly_reports", "groups"
  add_foreign_key "monthly_reports", "mentors"
end
