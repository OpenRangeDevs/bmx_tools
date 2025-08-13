class AddLocationToClubs < ActiveRecord::Migration[8.0]
  def change
    add_column :clubs, :location, :string
  end
end
