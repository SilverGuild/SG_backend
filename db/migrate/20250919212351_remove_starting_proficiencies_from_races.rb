class RemoveStartingProficienciesFromRaces < ActiveRecord::Migration[8.0]
  def change
    remove_column :races, :starting_proficiencies, :json
  end
end
