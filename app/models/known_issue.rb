class KnownIssue < ApplicationRecord
  belongs_to :organization
  has_many :tickets

  scope :active, -> { where.not(status: "deprecated") }

  def update_occurrence_stats!
    count = tickets.count
    update!(
      occurrence_count: count,
      first_seen_at: tickets.minimum(:created_at),
      last_seen_at:  tickets.maximum(:created_at)
    )
  end
end
