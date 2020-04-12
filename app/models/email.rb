class Email < ApplicationRecord
  belongs_to :initiative
  has_many :recipiants, dependent: :destroy
  has_many :representatives, through: :recipiants

end
