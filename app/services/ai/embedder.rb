module Ai
  class Embedder
    def self.call(ticket)
      # TODO: replace with real embedding call
      fake_vector = Array.new(1536) { rand * 0.01 }
      ticket.update!(embedding: fake_vector)
    end
  end
end
