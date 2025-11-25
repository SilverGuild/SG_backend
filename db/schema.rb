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

ActiveRecord::Schema[8.1].define(version: 2025_10_26_202310) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "characters", force: :cascade do |t|
    t.string "alignment"
    t.string "background"
    t.string "character_class_id"
    t.datetime "created_at", null: false
    t.integer "experience_points"
    t.string "languages", default: [], array: true
    t.integer "level"
    t.string "name"
    t.string "race_id"
    t.string "subclass_id"
    t.string "subrace_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["character_class_id"], name: "index_characters_on_character_class_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.datetime "updated_at", null: false
    t.string "username"
  end

  add_foreign_key "characters", "users"
end
