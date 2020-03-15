# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_12_004829) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dashboard_component_journals", force: :cascade do |t|
    t.integer "dashboard_component_id", null: false
    t.integer "journal_id", null: false
  end

  create_table "dashboard_components", force: :cascade do |t|
    t.integer "dashboard_id", null: false
    t.string "component_type", null: false
    t.integer "position", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dashboards", force: :cascade do |t|
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "journal_entries", force: :cascade do |t|
    t.integer "journal_id", null: false
    t.string "content_type", null: false
    t.integer "content_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "entry_date", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "journals", force: :cascade do |t|
    t.string "name", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "template", null: false
  end

  create_table "poetry_contents", force: :cascade do |t|
    t.string "title", null: false
    t.string "poem", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "professional_development_contents", force: :cascade do |t|
    t.string "title", null: false
    t.string "mood"
    t.string "today_i_learned"
    t.string "goal_progress"
    t.string "celebrations"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "dashboard_component_journals", "dashboard_components"
  add_foreign_key "dashboard_component_journals", "journals"
  add_foreign_key "dashboard_components", "dashboards"
  add_foreign_key "dashboards", "users"
  add_foreign_key "journal_entries", "journals"
  add_foreign_key "journals", "users"
end
