class Bill < ApplicationRecord
  has_many :votes, dependent: :destroy
  has_many :representatives, through: :votes
  has_many :bill_issues, dependent: :destroy
  has_many :issues, through: :bill_issues
  validates :location, :inclusion => { :in => ["US Senate", "US House", "NY State Senate", "NY State Assembly", "NYC City Council"], :message => "must be selected"}
  validates :session, :inclusion =>  { :in => (2000..2020).map(&:to_s), :message => "must be selected"}
  validates :name, :summary, presence: true
  validates :number, presence: true, number: true, unless: -> { session.blank? }
end
