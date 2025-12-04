class Ticket < ApplicationRecord
  belongs_to :organization
  belongs_to :known_issue, optional: true

  scope :open_tickets, -> { where(status: "open") }

  def needs_enrichment?
    summary.blank? || embedding.nil?
  end
end
