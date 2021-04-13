class AddFilerIdToLobbyist < ActiveRecord::Migration[6.0]
  def change
    add_column :lobbyists, :filer_id, :integer
  end
end
