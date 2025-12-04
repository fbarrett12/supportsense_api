class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :organization, null: false, foreign_key: true

      t.string :external_id
      t.string :source_system

      t.string :subject
      t.text :body
      t.text :summary

      t.string :status
      t.string :severity
      t.string :customer_identifier

      t.references :known_issues, null: true, foreign_key: true

      t.jsonb :tags, default: []

      t.datetime :first_seen_at
      t.datetime :last_updated_at

      t.column :embedding, 'vector(1536)'

      t.timestamps
    end

    add_index :tickets,
              [:organization_id, :external_id, :source_system],
              unique: true,
              name: "index_tickets_on_org_external_and_source"

    add_index :tickets, :tags, using: :gin

    execute <<~SQL
      CREATE INDEX index_tickets_on_embedding_ivfflat
      ON tickets
      USING ivfflat (embedding vector_cosine_ops)
      WITH (lists = 100);
    SQL
  end
end
