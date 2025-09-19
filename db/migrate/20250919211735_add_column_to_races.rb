class AddColumnToRaces < ActiveRecord::Migration[8.0]
  def change
    add_column :races, :languages, :json, default: []
  end
end
