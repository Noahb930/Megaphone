class CreateRepresentatives < ActiveRecord::Migration[6.0]
  def change
    create_table :representatives do |t|
      t.string :name
      t.string :district

      t.timestamps
    end
  end
end
