class CreateCharacters < ActiveRecord::Migration
  def change
    create_table :characters do |t|
      t.string :characterID
      t.string :name

      t.timestamps null: false
    end

    add_index :characters, :characterID, unique: true
  end
end
