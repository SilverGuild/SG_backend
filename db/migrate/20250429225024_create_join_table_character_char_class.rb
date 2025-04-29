class CreateJoinTableCharacterCharClass < ActiveRecord::Migration[7.2]
  def change
    create_join_table :characters, :charClasses do |t|
      # t.index [:character_id, :char_class_id]
      # t.index [:char_class_id, :character_id]
    end
  end
end
