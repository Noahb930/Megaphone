class Bill < ApplicationRecord
  has_many :votes
  has_many :representatives, through: :votes
  has_many :billissues
  has_many :issues, through: :billissues
end
