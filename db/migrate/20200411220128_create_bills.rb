class CreateBills < ActiveRecord::Migration[6.0]
  def change
    create_table :bills do |t|
      t.string :number
      t.string :shorthand
      t.string :status
      t.string :session
      t.string :summary
      t.string :url
      t.boolean :suppourts_gun_control

      t.timestamps
    end
  end
end
