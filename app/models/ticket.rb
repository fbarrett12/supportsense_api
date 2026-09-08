class Ticket < ApplicationRecord
  has_neighbors :embedding 
  
  belongs_to :organization
  belongs_to :known_issue, optional: true

  validates :external_id, :source_system, :subject, :body, presence: true
  validates :external_id, uniqueness: { scope: [:organization_id, :source_system] }
  validates :status, inclusion: { in: %w[open pending resolved closed] }
  validates :severity, inclusion: { in: %w[low medium high critical] }

  scope :open_tickets, -> { where(status: "open") }

  def needs_enrichment?
    summary.blank? || embedding.nil?
  end
end
