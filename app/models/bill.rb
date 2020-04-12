class Bill < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :representatives, through: :votes
  has_many :bill_issues, dependent: :destroy
  has_many :issues, through: :bill_issues
end
