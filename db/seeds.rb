org = Organization.find_or_create_by!(slug: "demo-org") { |record| record.name = "SupportSense Demo" }
User.find_or_create_by!(organization: org, email: "founder@demo.com") do |user|
  user.encrypted_password = "demo-only-not-for-production"
  user.role = "owner"
  user.name = "Fredrick Barrett"
end

issues = [
  { title: "PLM upload fails when UPC column is missing", description: "Catalog imports fail when the PLM template omits the UPC column.", root_cause: "The import validator expects a UPC column and throws a null-reference error when it is absent.", workaround: "Add a UPC column to the template, even when values are blank, then retry the upload.", permanent_fix: "Make UPC optional and return a field-level validation message.", severity_level: "high", status: "monitoring", tags: %w[upload upc plm catalog] },
  { title: "Invoice exports remain in processing", description: "Large invoice exports time out during peak processing windows.", root_cause: "Large export batches exceed the background worker timeout.", workaround: "Split the date range into weekly exports while Engineering drains the delayed queue.", permanent_fix: "Stream exports in resumable batches.", severity_level: "critical", status: "investigating", tags: %w[invoice export processing] },
  { title: "SSO redirect loop after domain update", description: "Users return to sign-in after successful SSO authentication.", root_cause: "The identity provider redirects to a stale callback domain cached in tenant configuration.", workaround: "Re-save SSO configuration and begin a new private browsing session.", permanent_fix: "Invalidate callback configuration caches when domains change.", severity_level: "medium", status: "fix_scheduled", tags: %w[sso login redirect domain] }
].map do |attributes|
  issue = org.known_issues.find_or_initialize_by(title: attributes[:title])
  issue.update!(attributes)
  issue
end

[
  { external_id: "ZEN-4821", source_system: "zendesk", subject: "Home Depot catalog upload returns generic error", body: "Our merchandising team cannot upload today's PLM file. The file does not include UPC because these are pre-release items.", severity: "high", customer_identifier: "Home Depot", known_issue: issues[0], match_confidence: 96 },
  { external_id: "ZEN-4818", source_system: "zendesk", subject: "Month-end invoices stuck processing", body: "The finance export has shown processing for 45 minutes and is blocking month-end close.", severity: "critical", customer_identifier: "Northstar Freight", known_issue: issues[1], match_confidence: 93 },
  { external_id: "INT-1094", source_system: "intercom", subject: "Users sent back to login after SSO", body: "Since updating our company domain, everyone returns to sign in after authenticating.", severity: "medium", customer_identifier: "Atlas Supply", known_issue: issues[2], match_confidence: 89 },
  { external_id: "ZEN-4807", source_system: "zendesk", subject: "Can we rename a saved report?", body: "Is there a way to rename a report without rebuilding it?", severity: "low", customer_identifier: "Marlow Retail" }
].each do |attributes|
  ticket = org.tickets.find_or_initialize_by(external_id: attributes[:external_id], source_system: attributes[:source_system])
  ticket.assign_attributes(attributes.merge(status: "open", tags: []))
  ticket.summary = nil
  ticket.save!
  Ai::Summarizer.call(ticket)
end

issues.each(&:update_occurrence_stats!)
