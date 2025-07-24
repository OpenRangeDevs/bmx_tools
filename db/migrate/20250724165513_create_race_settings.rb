class CreateRaceSettings < ActiveRecord::Migration[8.0]
  def change
    create_table :race_settings do |t|
      t.references :race, null: false, foreign_key: true
      t.time :registration_deadline
      t.time :race_start_time
      t.text :notification_message
      t.datetime :notification_expires_at

      t.timestamps
    end
  end
end
