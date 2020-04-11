class Lobbyist < ApplicationRecord
  has_many :donations
  has_many :representatives, through: :donations
end
