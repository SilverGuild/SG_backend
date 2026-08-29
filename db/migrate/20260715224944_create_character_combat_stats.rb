class CreateCharacterCombatStats < ActiveRecord::Migration[8.1]
  def change
    create_table :character_combat_stats do |t|
      t.references :character, null: false, foreign_key: true, index: { unique: true }

      t.integer :current_hp
      t.integer :max_hp
      t.integer :temporary_hp, default: 0

      t.integer :hit_dice_remaining

      t.integer :death_save_successes, default: 0
      t.integer :death_save_failures, default: 0
      t.boolean :stable, default: false

      t.integer :armor_class

      t.string :conditions, array: true, default: []

      t.timestamps
    end
  end
end
