class Issue < ApplicationRecord
  has_many :initiativeissues
  has_many :initiatives, through: :initiativeissues
  has_many :beliefs
  has_many :representatives, through: :beliefs
  has_many :billissues
  has_many :bills, through: :billissues
end
