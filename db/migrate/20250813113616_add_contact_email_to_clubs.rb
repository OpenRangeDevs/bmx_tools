class AddContactEmailToClubs < ActiveRecord::Migration[8.0]
  def change
    add_column :clubs, :contact_email, :string
  end
end
