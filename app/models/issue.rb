class Issue < ApplicationRecord
  has_many :beliefs, dependent: :destroy
  has_many :representatives, through: :beliefs
  has_many :bill_issues, dependent: :destroy
  has_many :bills, through: :bill_issues
end
