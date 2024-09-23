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

ActiveRecord::Schema[7.0].define(version: 2024_09_23_203125) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "class_years", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "majors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.boolean "can_moderate"
    t.boolean "can_promote"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "full_name"
    t.string "uid"
    t.string "avatar_url"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "role_id"
    t.string "bio"
    t.bigint "major_id"
    t.bigint "class_year_id"
    t.index ["class_year_id"], name: "index_users_on_class_year_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["major_id"], name: "index_users_on_major_id"
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "users", "class_years"
  add_foreign_key "users", "majors"
  add_foreign_key "users", "roles"
end
