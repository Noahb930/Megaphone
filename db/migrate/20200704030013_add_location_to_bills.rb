class AddLocationToBills < ActiveRecord::Migration[6.0]
  def change
    add_column :bills, :location, :string
  end
end
