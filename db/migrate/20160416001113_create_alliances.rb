class CreateAlliances < ActiveRecord::Migration
  def change
    create_table :alliances do |t|
      t.string :alliance_id
      t.string :alliance_name

      t.timestamps null: false
    end

    add_index :alliances, :alliance_id, unique: true
  end
end
