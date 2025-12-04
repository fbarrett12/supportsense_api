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
      summary: @ticket.summary,
      status: @ticket.status,
      severity: @ticket.severity,
      customer_identifier: @ticket.customer_identifier,
      known_issue_id: @ticket.known_issue_id,
      tags: @ticket.tags,
      created_at: @ticket.created_at,
      updated_at: @ticket.updated_at
    }
  end
end
