class Office < ApplicationRecord
  belongs_to :representative, dependent: :destroy
end
