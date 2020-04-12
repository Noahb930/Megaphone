class CreateOffices < ActiveRecord::Migration[6.0]
  def change
    create_table :offices do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :zipcode
      t.string :phone
      t.string :fax
      t.integer :representative_id
      t.timestamps
    end
  end
end
