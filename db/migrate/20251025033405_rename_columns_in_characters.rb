class RenameColumnsInCharacters < ActiveRecord::Migration[8.1]
  def change
    rename_column :characters, :character_class_name, :character_class_id
    rename_column :characters, :subclass_name, :subclass_id
    rename_column :characters, :race_name, :race_id
    rename_column :characters, :subrace_name, :subrace_id
  end
end
