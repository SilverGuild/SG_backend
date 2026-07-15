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

ActiveRecord::Schema[8.1].define(version: 2026_07_15_225003) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "character_ability_scores", force: :cascade do |t|
    t.string "ability_id"
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.boolean "saving_throw_proficient", default: false
    t.integer "score"
    t.datetime "updated_at", null: false
    t.index ["character_id", "ability_id"], name: "index_character_ability_scores_on_character_id_and_ability_id", unique: true
    t.index ["character_id"], name: "index_character_ability_scores_on_character_id"
  end

  create_table "character_combat_stats", force: :cascade do |t|
    t.integer "armor_class"
    t.bigint "character_id", null: false
    t.string "conditions", default: [], array: true
    t.datetime "created_at", null: false
    t.integer "current_hp"
    t.integer "death_save_failures", default: 0
    t.integer "death_save_successes", default: 0
    t.integer "hit_dice_remaining"
    t.integer "max_hp"
    t.boolean "stable", default: false
    t.integer "temporary_hp", default: 0
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_combat_stats_on_character_id", unique: true
  end

  create_table "character_skills", force: :cascade do |t|
    t.bigint "character_id", null: false
    t.datetime "created_at", null: false
    t.boolean "expertise", default: false
    t.boolean "proficient", default: false
    t.string "skill_id"
    t.datetime "updated_at", null: false
    t.index ["character_id", "skill_id"], name: "index_character_skills_on_character_id_and_skill_id", unique: true
    t.index ["character_id"], name: "index_character_skills_on_character_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "alignment"
    t.string "armor_proficiencies", default: [], array: true
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
    t.string "tool_proficiencies", default: [], array: true
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "weapon_proficiencies", default: [], array: true
    t.index ["character_class_id"], name: "index_characters_on_character_class_id"
    t.index ["race_id"], name: "index_characters_on_race_id"
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size", null: false
    t.datetime "created_at", null: false
    t.binary "key", null: false
    t.bigint "key_hash", null: false
    t.binary "value", null: false
    t.index ["byte_size"], name: "index_solid_cache_entries_on_byte_size"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "character_ability_scores", "characters"
  add_foreign_key "character_combat_stats", "characters"
  add_foreign_key "character_skills", "characters"
  add_foreign_key "characters", "users"
end
