class AddInitiativeIdToEmails < ActiveRecord::Migration[6.0]
  def change
    add_column :emails, :initiative_id, :integer
  end
end
