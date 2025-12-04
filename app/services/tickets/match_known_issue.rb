module Tickets
  class MatchKnownIssue
    def self.call(ticket)
      return if ticket.embedding.nil?

      org = ticket.organization
      candidates = org.known_issues.where.not(embedding: nil)
      return if candidates.empty?

      # TODO: replace with real vector search (using pgvector)
      # For now, just no-op or random.
      # Later: candidates.order("embedding <=> ?", ticket.embedding).limit(1)
    end
  end
end