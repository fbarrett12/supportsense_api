class CreateKnownIssues < ActiveRecord::Migration[7.1]
  def change
    create_table :known_issues do |t|
      t.references :organization, null: false, foreign_key: true

      t.string :title
      t.text :description

      t.text :root_cause
      t.text :workaround
      t.text :permanent_fix

      t.string :severity_level
      t.string :status

      t.jsonb :tags, default: []

      t.integer :occurrence_count, null: false, default: 0
      t.datetime :first_seen_at
      t.datetime :last_seen_at

      t.column :embedding, 'vector(1536)'

      t.timestamps
    end

    add_index :known_issues, [:organization_id, :title]
    add_index :known_issues, :tags, using: :gin

    execute <<~SQL
      CREATE INDEX index_known_issues_on_embedding_ivfflat
      ON known_issues
      USING ivfflat (embedding vector_cosine_ops)
      WITH (lists = 100);
    SQL
  end
end
