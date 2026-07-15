class CreateCharacterAbilityScores < ActiveRecord::Migration[8.1]
  def change
    create_table :character_ability_scores do |t|
      t.references :character, null: false, foreign_key: true
      t.string :ability_id
      t.integer :score
      t.boolean :saving_throw_proficient, default: false

      t.timestamps
    end

    add_index :character_ability_scores, [ :character_id, :ability_id ], unique: true
  end
end
