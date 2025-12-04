class User < ApplicationRecord
  belongs_to :organization

  enum :role, { agent: "agent", admin: "admin", owner: "owner" }
end
