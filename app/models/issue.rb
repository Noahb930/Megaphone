class Issue < ApplicationRecord
  has_many :initiative_issues
  has_many :initiatives, through: :initiative_issues
  has_many :beliefs
  has_many :representatives, through: :beliefs
  has_many :bill_issues
  has_many :bills, through: :bill_issues
end
