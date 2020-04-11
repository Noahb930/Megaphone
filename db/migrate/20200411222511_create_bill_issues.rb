class CreateBillIssues < ActiveRecord::Migration[6.0]
  def change
    create_table :bill_issues do |t|
      t.integer :bill_id
      t.integer :issue_id

      t.timestamps
    end
  end
end
