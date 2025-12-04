module Ai
  class Summarizer
    def self.call(ticket)
      return if ticket.summary.present?

      summary = "TODO: call LLM to summarize ticket body"
      ticket.update!(summary: summary)
    end
  end
end
