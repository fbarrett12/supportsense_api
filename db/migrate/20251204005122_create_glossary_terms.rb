class CreateGlossaryTerms < ActiveRecord::Migration[7.1]
  def change
    create_table :glossary_terms do |t|
      t.references :organization, null: false, foreign_key: true

      t.string :term
      t.text :meaning
      t.text :internal_notes

      t.jsonb :tags, null: false, default: []
      t.jsonb :example_snippets, null: false, default: []

      t.timestamps
    end

    add_index :glossary_terms, [:organization_id, :term], unique: true
    add_index :glossary_terms, :tags, using: :gin
  end
end
