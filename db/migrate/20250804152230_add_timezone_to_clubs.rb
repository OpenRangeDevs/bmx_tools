class AddTimezoneToClubs < ActiveRecord::Migration[8.0]
  def change
    add_column :clubs, :timezone, :string, default: "Mountain Time (US & Canada)", null: false
  end
end
