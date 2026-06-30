class AddAuthConstraintsToUsers < ActiveRecord::Migration[8.1]
  def change
    change_column_null :users, :username, false
    change_column_null :users, :email, false
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
