class BillIssue < ApplicationRecord
  belongs_to :bill
  belongs_to :issue
end
