class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :character_id
      t.string :character_name

      t.string :corporation_id
      t.string :alliance_id

      t.timestamps null: false
    end

    add_index :characters, :character_id, unique: true
  end
end
