class ChangeTemplateToEmailTemplate < ActiveRecord::Migration[6.0]
  def change
    rename_table :templates, :email_templates
    rename_column :recipiants, :template_id, :email_template_id
  end
end
