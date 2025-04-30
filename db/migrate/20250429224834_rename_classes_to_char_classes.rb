class RenameClassesToCharClasses < ActiveRecord::Migration[7.2]
  def change
    rename_table :classes, :charClasses
  end
end
