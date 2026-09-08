class TicketSerializer
  def initialize(ticket)
    @ticket = ticket
  end

  def as_json(*)
    {
      id: @ticket.id,
      external_id: @ticket.external_id,
      source_system: @ticket.source_system,
      subject: @ticket.subject,
      body: @ticket.body,
      summary: @ticket.summary,
      status: @ticket.status,
      severity: @ticket.severity,
      customer_identifier: @ticket.customer_identifier,
      known_issue_id: @ticket.known_issue_id,
      match_confidence: @ticket.match_confidence,
      tags: @ticket.tags,
      created_at: @ticket.created_at,
      updated_at: @ticket.updated_at,
      age: age
    }
  end

  private

  def age
    seconds = (Time.current - @ticket.created_at).to_i
    return "now" if seconds < 60
    return "#{seconds / 60}m" if seconds < 3_600

    "#{seconds / 3_600}h"
  end
end
