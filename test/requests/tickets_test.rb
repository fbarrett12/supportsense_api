require "test_helper"

class TicketsRequestTest < ActionDispatch::IntegrationTest
  setup do
    @organization = Organization.create!(name: "Demo", slug: "demo")
    @organization.known_issues.create!(title: "Invoice export stuck processing", description: "Exports time out", root_cause: "Worker timeout", workaround: "Split the export", severity_level: "critical", status: "monitoring", tags: %w[invoice export processing])
  end

  test "creates, enriches, and returns a ticket" do
    post "/api/v1/tickets", params: { ticket: { external_id: "ZEN-1", source_system: "zendesk", subject: "Invoice export stuck", body: "Our invoice export is still processing", status: "open", severity: "critical", customer_identifier: "Northstar" } }, as: :json
    assert_response :created
    payload = response.parsed_body
    assert_equal "ZEN-1", payload["external_id"]
    assert payload["summary"].present?
    assert payload["known_issue_id"].present?
    assert payload["match_confidence"] >= 88
  end

  test "rejects an invalid ticket" do
    post "/api/v1/tickets", params: { ticket: { subject: "Missing required fields" } }, as: :json
    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].any?
  end
end
