class AddStateToOffice < ActiveRecord::Migration[6.0]
  def change
    add_column :offices, :state, :string
  end
end
