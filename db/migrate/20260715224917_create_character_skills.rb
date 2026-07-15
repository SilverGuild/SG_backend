class CreateCharacterSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :character_skills do |t|
      t.references :character, null: false, foreign_key: true
      t.string :skill_id
      t.boolean :proficient, default: false
      t.boolean :expertise, default: false

      t.timestamps
    end

    add_index :character_skills, [ :character_id, :skill_id ], unique: true
  end
end
