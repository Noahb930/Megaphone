class AddForeignKeys < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :offices, :representatives
    add_foreign_key :donations, :representatives
    add_foreign_key :donations, :lobbyists
    add_foreign_key :votes, :representatives
    add_foreign_key :votes, :bills
    add_foreign_key :recipiants, :representatives
    add_foreign_key :recipiants, :emails
    # add_foreign_key :emails, :initiatives
    add_foreign_key :beliefs, :representatives
    add_foreign_key :beliefs, :issues
    add_foreign_key :bill_issues, :issues
    add_foreign_key :bill_issues, :bills
    # add_foreign_key :initiative_issues, :issues
    # add_foreign_key :initiative_issues, :initiatives
  end
end
