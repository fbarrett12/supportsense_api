require "test_helper"

class Ai::SummarizerTest < ActiveSupport::TestCase
  test "creates a deterministic summary and preserves an existing one" do
    ticket = create_organization.tickets.create!(external_id: "T-1", source_system: "zendesk", subject: "Export is stuck", body: "The customer cannot finish month-end close.", status: "open", severity: "high")
    Ai::Summarizer.call(ticket)
    assert_includes ticket.reload.summary, "issue is blocking"

    ticket.update!(summary: "Agent-approved summary")
    Ai::Summarizer.call(ticket)
    assert_equal "Agent-approved summary", ticket.reload.summary
  end
end
