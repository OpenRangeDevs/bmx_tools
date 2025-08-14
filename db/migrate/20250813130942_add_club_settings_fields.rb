class AddClubSettingsFields < ActiveRecord::Migration[8.0]
  def change
    add_column :clubs, :owner_user_id, :bigint
    add_column :clubs, :website_url, :string
    add_column :clubs, :description, :text
    add_foreign_key :clubs, :users, column: :owner_user_id
  end
end
