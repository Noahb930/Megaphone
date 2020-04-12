class Bill < ApplicationRecord
  has_many :votes
  has_many :representatives, through: :votes
  has_many :bill_issues
  has_many :issues, through: :bill_issues
end
