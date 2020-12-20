class ChangeShorthandToName < ActiveRecord::Migration[6.0]
  def change
    rename_column :bills, :shorthand, :name
  end
end
