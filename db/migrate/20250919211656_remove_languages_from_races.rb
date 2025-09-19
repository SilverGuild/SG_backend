class RemoveLanguagesFromRaces < ActiveRecord::Migration[8.0]
  def change
    remove_column :races, :languages, :string
  end
end
