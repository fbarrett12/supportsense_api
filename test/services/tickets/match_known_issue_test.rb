require "test_helper"

class Tickets::MatchKnownIssueTest < ActiveSupport::TestCase
  setup do
    @organization = create_organization
    @issue = @organization.known_issues.create!(title: "PLM upload missing UPC", description: "Catalog upload validation fails", root_cause: "Missing column", workaround: "Add UPC column", severity_level: "high", status: "monitoring", tags: %w[plm upload upc])
  end

  test "links a ticket when multiple signals overlap" do
    ticket = @organization.tickets.create!(external_id: "T-2", source_system: "zendesk", subject: "PLM upload fails", body: "The UPC column is missing", status: "open", severity: "high")
    assert_equal @issue, Tickets::MatchKnownIssue.call(ticket)
    assert_equal @issue, ticket.reload.known_issue
    assert_operator ticket.match_confidence, :>=, 88
    assert_equal 1, @issue.reload.occurrence_count
  end

  test "does not force a weak match" do
    ticket = @organization.tickets.create!(external_id: "T-3", source_system: "zendesk", subject: "Rename my report", body: "How can I change its title?", status: "open", severity: "low")
    assert_nil Tickets::MatchKnownIssue.call(ticket)
    assert_nil ticket.reload.known_issue
  end
end
