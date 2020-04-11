class Email < ApplicationRecord
  belongs_to :initiative
  has_many :recipiants
  has_many :representatives, through :recipiants

end
