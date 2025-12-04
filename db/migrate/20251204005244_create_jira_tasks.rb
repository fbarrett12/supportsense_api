class CreateJiraTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :jira_tasks do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :known_issue, null: false, foreign_key: true

      t.string :issue_key
      t.string :summary
      t.text :description
      t.string :status

      t.jsonb :ticket_ids, null: false, default: []

      t.timestamps
    end

    add_index :jira_tasks, :issue_key
  end
end
