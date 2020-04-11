class CreateRecipiants < ActiveRecord::Migration[6.0]
  def change
    create_table :recipiants do |t|
      t.integer :representative_id
      t.integer :email_id

      t.timestamps
    end
  end
end
