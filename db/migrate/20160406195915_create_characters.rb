class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :characterID
      t.string :characterName

      t.string :corporationID
      t.string :corporation

      t.string :allianceID
      t.string :alliance

      t.timestamps null: false
    end

    add_index :characters, :characterID, unique: true
  end
end
