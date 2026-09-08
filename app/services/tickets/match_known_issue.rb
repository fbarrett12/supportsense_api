module Tickets
  class MatchKnownIssue
    def self.call(ticket)
      org = ticket.organization
      candidates = org.known_issues.active
      return if candidates.empty?

      ticket_tokens = tokenize("#{ticket.subject} #{ticket.body}")
      matches = candidates.map do |issue|
        issue_tokens = tokenize([issue.title, issue.description, issue.tags.join(" ")].join(" "))
        overlap = (ticket_tokens & issue_tokens).size
        [issue, overlap]
      end
      issue, overlap = matches.max_by { |(_, score)| score }
      return if overlap < 2

      confidence = [82 + (overlap * 3), 97].min
      ticket.update!(known_issue: issue, match_confidence: confidence)
      issue.update_occurrence_stats!
      issue
    end

    def self.tokenize(text)
      text.downcase.scan(/[a-z0-9]+/).reject { |token| token.length < 3 }
    end
  end
end
