class AddColumnToCharacters < ActiveRecord::Migration[8.1]
  def change
    add_column :characters, :languages, :string, array: true, default: []
  end
end
