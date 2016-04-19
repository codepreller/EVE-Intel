class CreateAllianceInReports < ActiveRecord::Migration
  def change
    create_table :alliance_in_reports do |t|
      t.timestamps null: false
    end
  end
end
