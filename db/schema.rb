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

ActiveRecord::Schema.define(version: 2022_12_14_083530) do

  create_table "articles", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.string "title"
    t.text "content"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_articles_on_employee_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "employees", force: :cascade do |t|
    t.integer "department_id", null: false
    t.integer "office_id", null: false
    t.string "number", null: false
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "account", null: false
    t.string "password", null: false
    t.string "email", null: false
    t.date "date_of_joining", null: false
    t.boolean "employee_info_manage_auth", default: false, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "news_posting_auth", default: false, null: false
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["office_id"], name: "index_employees_on_office_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "profiles", force: :cascade do |t|
    t.integer "employee_id", null: false
    t.text "profile", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["employee_id"], name: "index_profiles_on_employee_id"
  end

  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "offices"
  add_foreign_key "profiles", "employees"
end
