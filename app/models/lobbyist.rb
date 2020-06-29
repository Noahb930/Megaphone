class Lobbyist < ApplicationRecord
  has_many :contributions, dependent: :destroy
  has_many :representatives, through: :contributions
end
