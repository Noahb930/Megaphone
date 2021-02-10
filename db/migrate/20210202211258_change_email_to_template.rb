class ChangeEmailToTemplate < ActiveRecord::Migration[6.0]
  def change
    rename_table :emails, :templates
    rename_column :recipiants, :email_id, :template_id
    add_column :templates, :name, :string
    add_column :templates, :is_active, :boolean
  end
end
