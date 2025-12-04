# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_12_04_005244) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "glossary_terms", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "term"
    t.text "meaning"
    t.text "internal_notes"
    t.jsonb "tags", default: [], null: false
    t.jsonb "example_snippets", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "term"], name: "index_glossary_terms_on_organization_id_and_term", unique: true
    t.index ["organization_id"], name: "index_glossary_terms_on_organization_id"
    t.index ["tags"], name: "index_glossary_terms_on_tags", using: :gin
  end

  create_table "jira_tasks", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "known_issue_id", null: false
    t.string "issue_key"
    t.string "summary"
    t.text "description"
    t.string "status"
    t.jsonb "ticket_ids", default: [], null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_key"], name: "index_jira_tasks_on_issue_key"
    t.index ["known_issue_id"], name: "index_jira_tasks_on_known_issue_id"
    t.index ["organization_id"], name: "index_jira_tasks_on_organization_id"
  end

# Could not dump table "known_issues" because of following StandardError
#   Unknown type 'vector(1536)' for column 'embedding'

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.jsonb "settings", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

# Could not dump table "tickets" because of following StandardError
#   Unknown type 'vector(1536)' for column 'embedding'

  create_table "users", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "role", default: "agent", null: false
    t.string "name"
    t.string "time_zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "email"], name: "index_users_on_organization_id_and_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
  end

  add_foreign_key "glossary_terms", "organizations"
  add_foreign_key "jira_tasks", "known_issues"
  add_foreign_key "jira_tasks", "organizations"
  add_foreign_key "known_issues", "organizations"
  add_foreign_key "tickets", "known_issues", column: "known_issues_id"
  add_foreign_key "tickets", "organizations"
  add_foreign_key "users", "organizations"
end
