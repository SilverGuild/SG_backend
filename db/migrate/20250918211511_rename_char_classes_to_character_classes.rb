class RenameCharClassesToCharacterClasses < ActiveRecord::Migration[8.0]
  def change
    rename_table :charClasses, :character_classes
  end
end
