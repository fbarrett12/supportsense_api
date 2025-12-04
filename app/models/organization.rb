class Organization < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :known_issues, dependent: :destroy
  has_many :glossary_terms, dependent: :destroy
  has_many :jira_tasks, dependent: :destroy
end
