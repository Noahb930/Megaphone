class Representative < ApplicationRecord
  has_many :beliefs
  has_many :issues, through: :beliefs
  has_many :votes
  has_many :bills, through: :votes
  has_many :donations
  has_many :lobbyists, through: :donations
  has_many :recipiants
  has_many :emails, through: :recipiants
  has_many :offices
end
