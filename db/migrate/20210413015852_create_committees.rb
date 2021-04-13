class CreateCommittees < ActiveRecord::Migration[6.0]
  def change
    create_table :committees do |t|
      t.string :name
      t.integer :filer_id
      t.integer :representative_id
      t.timestamps
    end
    add_foreign_key :committees, :representatives
  end
end
