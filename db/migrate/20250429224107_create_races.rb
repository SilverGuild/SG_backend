class CreateRaces < ActiveRecord::Migration[7.2]
  def change
    create_table :races do |t|
      t.string :name
      t.string :description
      t.integer :speed
      t.string :size

      t.timestamps
    end
  end
end
