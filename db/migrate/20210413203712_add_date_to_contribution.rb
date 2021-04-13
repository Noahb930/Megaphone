class AddDateToContribution < ActiveRecord::Migration[6.0]
  def change
    add_column :contributions, :date, :date
  end
end
