class CreateReportInformations < ActiveRecord::Migration
  def change
    create_table :report_informations do |t|
      t.belongs_to :report

      t.string :character_id
      t.string :character_name
      t.string :alliance_id
      t.string :alliance_name
      t.string :corporation_id
      t.string :corporation_name

      t.timestamps null: false
    end
  end
end
