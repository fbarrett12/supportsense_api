class JiraTask < ApplicationRecord
  belongs_to :organization
  belongs_to :known_issue, optional: true
end
