class AddColumnsToRaces < ActiveRecord::Migration[8.0]
  def change
    add_column :races, :ability_bonuses, :json, default: []
    add_column :races, :age_description, :string
    add_column :races, :alignment_description, :string
    add_column :races, :size_description, :string
    add_column :races, :starting_proficiencies, :json, default: []
    add_column :races, :languages, :string
    add_column :races, :languages_description, :string
  end
end
