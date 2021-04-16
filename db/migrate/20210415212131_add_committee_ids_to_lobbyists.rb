class AddCommitteeIdsToLobbyists < ActiveRecord::Migration[6.0]
  def change
    add_column :lobbyists, :fec_committee_ids, :string, array: TRUE,
    add_column :lobbyists, :nysboe_committee_ids, :integer, array: TRUE,
    remove_column :lobbyists, :filer_id
  end
end
