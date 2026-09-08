ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  parallelize(workers: 1)

  setup do
    JiraTask.delete_all
    Ticket.delete_all
    KnownIssue.delete_all
    User.delete_all
    Organization.delete_all
  end

  def create_organization
    Organization.create!(name: "Demo", slug: "demo-#{SecureRandom.hex(4)}")
  end
end
