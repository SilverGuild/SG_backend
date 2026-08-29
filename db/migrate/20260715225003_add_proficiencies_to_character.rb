class AddProficienciesToCharacter < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :armor_proficiencies, :string, array: true, default: []
    add_column :characters, :weapon_proficiencies, :string, array: true, default: []
    add_column :characters, :tool_proficiencies, :string, array: true, default: []
  end
end
