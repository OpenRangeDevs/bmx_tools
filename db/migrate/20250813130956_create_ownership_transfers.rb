class CreateOwnershipTransfers < ActiveRecord::Migration[8.0]
  def change
    create_table :ownership_transfers do |t|
      t.references :club, null: false, foreign_key: true
      t.references :from_user, null: false, foreign_key: { to_table: :users }
      t.string :to_user_email, null: false
      t.string :token, null: false
      t.datetime :expires_at, null: false
      t.datetime :completed_at
      t.datetime :cancelled_at

      t.timestamps
    end

    add_index :ownership_transfers, :token, unique: true
  end
end
