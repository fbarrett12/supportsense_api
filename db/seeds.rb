org = Organization.find_or_create_by!(slug: "demo-org") do |o|
  o.name = "Demo Organization"
end

user = User.find_or_create_by!(organization: org, email: "founder@demo.com") do |u|
  u.encrypted_password = "TODO-use-devise-or-bcrypt"
  u.role = "owner"
end

issue = KnownIssue.find_or_create_by!(organization: org, title: "Home Depot PLM upload fails without UPC") do |ki|
  ki.description = "Uploads fail when UPC column is missing in the PLM template."
  ki.root_cause  = "Validator assumes UPC presence and throws a null reference error."
  ki.workaround  = "Ensure all uploads include a UPC column, even if blank."
  ki.permanent_fix = "Relax validator to handle missing UPC and provide better error messages."
  ki.severity_level = "high"
  ki.status = "monitoring"
end

Ticket.find_or_create_by!(
  organization: org,
  external_id: "ZENDESK-1",
  source_system: "zendesk"
) do |t|
  t.subject = "Upload failing for Home Depot PLM template"
  t.body    = "Customer reports upload fails with generic error when sending PLM file without UPC."
  t.summary = "Home Depot PLM upload fails when UPC column is missing."
  t.status  = "open"
  t.severity = "high"
  t.customer_identifier = "home_depot"
  t.known_issues_id = issue.id
  t.tags = ["home_depot", "plm", "upload", "upc_missing"]
  t.first_seen_at = Time.current
  t.last_updated_at = Time.current
end

