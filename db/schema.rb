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

ActiveRecord::Schema[7.2].define(version: 2025_04_29_225024) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charClasses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "hit_die"
    t.string "primary_ability"
    t.string "saving_throw_proficiencies"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "charClasses_characters", id: false, force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "charClass_id", null: false
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.integer "level"
    t.integer "experience_points"
    t.string "alignment"
    t.string "background"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "characters_races", id: false, force: :cascade do |t|
    t.bigint "character_id", null: false
    t.bigint "race_id", null: false
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "speed"
    t.string "size"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subclasses", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subraces", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "characters", "users"
end
