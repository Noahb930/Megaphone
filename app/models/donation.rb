class Donation < ApplicationRecord
  belongs_to :representative
  belongs_to :lobbyist
end
