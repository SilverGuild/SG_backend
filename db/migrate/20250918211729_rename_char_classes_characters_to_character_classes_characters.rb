class RenameCharClassesCharactersToCharacterClassesCharacters < ActiveRecord::Migration[8.0]
  def change
     rename_table :charClasses_characters, :characters_char_classes
  end
end
