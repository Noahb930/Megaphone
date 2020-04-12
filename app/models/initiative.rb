class Initiative < ApplicationRecord
  has_many :emails
  has_many :initiative_issues
  has_many :issues, through: :initiative_issues
end
