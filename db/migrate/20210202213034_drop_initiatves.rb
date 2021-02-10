class DropInitiatves < ActiveRecord::Migration[6.0]
  def change
    remove_foreign_key :templates, :initiatives
    remove_foreign_key :initiative_issues, :initiatives
    remove_foreign_key :initiative_issues, :issues
    drop_table :initiative_issues
    drop_table :initiatives
  end
end
