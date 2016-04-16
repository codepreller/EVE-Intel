class CreateAlliances < ActiveRecord::Migration
  def change
    create_table :alliances do |t|
      t.string :id
      t.string :name

      t.timestamps null: false
    end
  end
end
