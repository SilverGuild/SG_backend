class AddColumnsToCharacterClasses < ActiveRecord::Migration[8.0]
  def change
    add_column :character_classes, :hit_die, :integer
    add_column :character_classes, :skill_proficiencies, :json, default: []
    add_column :character_classes, :saving_throw_proficiencies, :json, default: []
  end
end
