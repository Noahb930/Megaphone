class Recipiant < ApplicationRecord
  belongs_to :representative
  belongs_to :template
end
