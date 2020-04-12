class Initiative < ApplicationRecord
  has_many :emails, dependent: :destroy
  has_many :initiative_issues, dependent: :destroy
  has_many :issues, through: :initiative_issues
end
