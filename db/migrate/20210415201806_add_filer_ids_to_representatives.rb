class AddFilerIdsToRepresentatives < ActiveRecord::Migration[6.0]
  def change
    add_column :representatives, :fec_id, :string
  end
end
