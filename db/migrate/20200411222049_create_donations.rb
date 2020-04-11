class CreateDonations < ActiveRecord::Migration[6.0]
  def change
    create_table :donations do |t|
      t.integer :amount
      t.integer :lobbyist_id
      t.integer :representative_id

      t.timestamps
    end
  end
end
