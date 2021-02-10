require 'open-uri'
class Representative < ApplicationRecord
  has_many :beliefs, dependent: :destroy
  has_many :issues, through: :beliefs
  has_many :votes, dependent: :destroy
  has_many :bills, through: :votes
  has_many :contributions, dependent: :destroy
  has_many :lobbyists, through: :contributions
  has_many :recipiants, dependent: :destroy
  has_many :templates, through: :recipiants
  has_many :offices, dependent: :destroy

  validates :name, :profession, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, :allow_blank => true
  validates :party, format: { with: /\([DRI?](, [A-Z]{1,4})*\)/}, :allow_blank => true
  validates :district, format: { with: /District \d*/}, unless: :is_us_senator?
  validates :rating, format: { with: /[ABCDEF?][+-]?/}

  def is_us_senator?
    profession == "US Senator"
  end
end
