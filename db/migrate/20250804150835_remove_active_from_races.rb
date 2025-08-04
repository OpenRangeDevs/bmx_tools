class RemoveActiveFromRaces < ActiveRecord::Migration[8.0]
  def change
    remove_column :races, :active, :boolean
  end
end
