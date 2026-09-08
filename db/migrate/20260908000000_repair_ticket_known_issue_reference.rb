class RepairTicketKnownIssueReference < ActiveRecord::Migration[7.1]
  def change
    if column_exists?(:tickets, :known_issues_id) && !column_exists?(:tickets, :known_issue_id)
      rename_column :tickets, :known_issues_id, :known_issue_id
    end

    add_column :tickets, :match_confidence, :integer unless column_exists?(:tickets, :match_confidence)
  end
end
