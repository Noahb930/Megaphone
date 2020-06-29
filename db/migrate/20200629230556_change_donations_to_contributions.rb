class ChangeDonationsToContributions < ActiveRecord::Migration[6.0]
  def change
    rename_table :donations, :contributions
  end
end
