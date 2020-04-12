class Representative < ApplicationRecord
  has_many :beliefs, dependent: :destroy
  has_many :issues, through: :beliefs
  has_many :votes, dependent: :destroy
  has_many :bills, through: :votes
  has_many :donations, dependent: :destroy
  has_many :lobbyists, through: :donations
  has_many :recipiants, dependent: :destroy
  has_many :emails, through: :recipiants
  has_many :offices, dependent: :destroy


end
