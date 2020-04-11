class InitiativeIssue < ApplicationRecord
  belongs_to :initiative
  belongs_to :issue
end
