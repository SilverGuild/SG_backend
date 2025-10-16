class RemoveUnusedTables < ActiveRecord::Migration[8.0]
  def change
    drop_table :characters_char_classes, if_exists: true
    drop_table :characters_races, if_exists: true
    drop_table :character_classes, if_exists: true
    drop_table :races, if_exists: true
    drop_table :subclasses, if_exists: true
    drop_table :subraces, if_exists: true
  end
end
