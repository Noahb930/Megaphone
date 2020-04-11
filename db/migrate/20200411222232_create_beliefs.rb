class CreateBeliefs < ActiveRecord::Migration[6.0]
  def change
    create_table :beliefs do |t|
      t.string :description
      t.string :representative_id
      t.string :issue_id

      t.timestamps
    end
  end
end
