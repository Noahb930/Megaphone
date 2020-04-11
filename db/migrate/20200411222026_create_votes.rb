class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.string :stance
      t.integer :bill_id
      t.integer :representative_id

      t.timestamps
    end
  end
end
