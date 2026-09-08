module Ai
  class Embedder
    def self.call(ticket)
      # Deterministic local embeddings keep the demo reliable. Replace this
      # adapter with an external embedding provider without changing callers.
      tokens = "#{ticket.subject} #{ticket.body}".downcase.scan(/[a-z0-9]+/)
      vector = Array.new(1536, 0.0)
      tokens.each { |token| vector[token.bytes.sum % vector.length] += 1.0 }
      magnitude = Math.sqrt(vector.sum { |value| value * value })
      vector.map! { |value| magnitude.zero? ? value : value / magnitude }
      ticket.update!(embedding: vector)
    end
  end
end
