class Template < ApplicationRecord
  has_many :recipiants, dependent: :destroy
  has_many :representatives, through: :recipiants
end
