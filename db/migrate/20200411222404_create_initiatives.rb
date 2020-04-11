class CreateInitiatives < ActiveRecord::Migration[6.0]
  def change
    create_table :initiatives do |t|
      t.string :name
      t.string :description
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
