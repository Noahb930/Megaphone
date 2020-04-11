class Initiative < ApplicationRecord
  has_many :emails
  has_many :initiativeissues
  has_many :issues, through: :initiativeissues
end
