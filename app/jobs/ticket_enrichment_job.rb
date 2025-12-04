class TicketEnrichmentJob < ApplicationJob
  queue_as :default

  def perform(ticket_id)
    ticket = Ticket.find_by(id: ticket_id)
    return unless ticket

    Ai::Summarizer.call(ticket)
    Ai::Embedder.call(ticket)
    Tickets::MatchKnownIssue.call(ticket)
  end
end
