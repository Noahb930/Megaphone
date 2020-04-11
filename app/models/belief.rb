class Belief < ApplicationRecord
  belongs_to :representative
  belongs_to :issue
end
