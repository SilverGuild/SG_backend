class RemoveHitDieFromCharClasses < ActiveRecord::Migration[8.0]
  def change
    remove_column :charClasses, :hit_die, :string
  end
end
