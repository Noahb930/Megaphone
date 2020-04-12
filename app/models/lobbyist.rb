class Lobbyist < ApplicationRecord
  has_many :donations, dependent: :destroy
  has_many :representatives, through: :donations
end
