class AddCharacterClassAndRaceToCharacters < ActiveRecord::Migration[8.0]
  def change
    add_column :characters, :character_class_name, :string
    add_column :characters, :subclass_name, :string
    add_column :characters, :race_name, :string
    add_column :characters, :subrace_name, :string

    add_index :characters, :character_class_name
    add_index :characters, :race_name
  end
end
