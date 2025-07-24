class CreateRaces < ActiveRecord::Migration[8.0]
  def change
    create_table :races do |t|
      t.integer :at_gate, default: 0, null: false
      t.integer :in_staging, default: 0, null: false
      t.boolean :active, default: true, null: false
      t.references :club, null: false, foreign_key: true

      t.timestamps
    end
  end
end
