class CreateToolPermissions < ActiveRecord::Migration[8.0]
  def change
    create_table :tool_permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :tool, null: false, default: 0
      t.integer :role, null: false
      t.references :club, foreign_key: true  # nullable for super_admin

      t.timestamps
    end
    
    add_index :tool_permissions, [:user_id, :tool, :club_id], unique: true
  end
end
