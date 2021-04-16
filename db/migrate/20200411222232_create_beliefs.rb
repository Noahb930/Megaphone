class CreateBeliefs < ActiveRecord::Migration[6.0]
  def change
    create_table :beliefs do |t|
      t.string :description
      t.integer :representative_id
      t.integer :issue_id

      t.timestamps
    end
  end
end
