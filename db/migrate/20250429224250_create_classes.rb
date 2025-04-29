class CreateClasses < ActiveRecord::Migration[7.2]
  def change
    create_table :classes do |t|
      t.string :name
      t.string :description
      t.string :hit_die
      t.string :primary_ability
      t.string :saving_throw_proficiencies

      t.timestamps
    end
  end
end
