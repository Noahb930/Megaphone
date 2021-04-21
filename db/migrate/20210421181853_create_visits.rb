class CreateVisits < ActiveRecord::Migration[6.0]
  def change
    create_table :visits do |t|
      t.float :lat
      t.float :lng
      t.datetime :time
      t.string :state_senate_district
      t.string :state_assembly_district
      t.string :us_house_district
      t.timestamps
    end
  end
end
