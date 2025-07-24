class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :clubs, :slug, unique: true
  end
end
