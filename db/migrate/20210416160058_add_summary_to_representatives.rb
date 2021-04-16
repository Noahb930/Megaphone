class AddSummaryToRepresentatives < ActiveRecord::Migration[6.0]
  def change
    add_column :representatives, :summary, :string
  end
end
