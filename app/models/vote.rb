class Vote < ApplicationRecord
  belongs_to :representative
  belongs_to :bill
end
