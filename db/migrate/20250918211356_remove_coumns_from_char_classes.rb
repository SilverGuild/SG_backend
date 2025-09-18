class RemoveCoumnsFromCharClasses < ActiveRecord::Migration[8.0]
  def change
    remove_column :charClasses, :primary_ability, :string
    remove_column :charClasses, :saving_throw_proficiencies, :string
  end
end
