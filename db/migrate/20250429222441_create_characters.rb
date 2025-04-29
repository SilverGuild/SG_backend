class CreateCharacters < ActiveRecord::Migration[7.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :level
      t.integer :experience_points
      t.string :alignment
      t.string :background
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
