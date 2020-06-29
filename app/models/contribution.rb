class Contribution < ApplicationRecord
  belongs_to :representative
  belongs_to :lobbyist
end
