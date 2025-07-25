class CreateRaceActivities < ActiveRecord::Migration[8.0]
  def change
    create_table :race_activities do |t|
      t.references :race, null: true, foreign_key: true
      t.references :club, null: false, foreign_key: true
      t.string :activity_type, null: false
      t.text :message, null: false
      t.json :metadata, default: {}
      t.timestamps
    end

    add_index :race_activities, [:club_id, :created_at]
    add_index :race_activities, :activity_type
  end
end