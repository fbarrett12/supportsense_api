module Ai
  class Summarizer
    def self.call(ticket)
      return if ticket.summary.present?

      body = ticket.body.to_s.gsub(/\s+/, " ").strip
      body = "#{body.first(177)}..." if body.length > 180
      impact = body.match?(/blocked|cannot|fails?|stuck|outage/i) ? " The issue is blocking an active customer workflow." : ""
      summary = "#{ticket.customer_identifier.presence || 'Customer'} reports #{ticket.subject.downcase}. #{body}#{impact}".squish
      ticket.update!(summary: summary)
    end
  end
end
