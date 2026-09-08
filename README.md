# SupportSense API

SupportSense is a Rails API for support-ticket triage. It ingests a ticket, produces a deterministic summary and embedding, matches repeated incidents to known issues, and returns the recommended workaround. The deterministic adapters make the demo reliable and define clean seams for production LLM and embedding providers.

## Demo flow

1. `POST /api/v1/tickets` with an incoming customer message.
2. `TicketEnrichmentJob` summarizes and embeds the ticket.
3. `Tickets::MatchKnownIssue` links a sufficiently strong knowledge-base match.
4. The response includes the summary, match confidence, and known-issue ID.

## Setup

Requirements: Ruby 3.1.6, PostgreSQL, and the `vector` PostgreSQL extension.

```bash
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

The API runs at `http://localhost:3000`. `FRONTEND_ORIGINS` accepts a comma-separated list of additional allowed frontend origins.

## Test

```bash
bin/rails test
```

The suite covers deterministic summarization, strong and weak known-issue matching, enriched ticket creation, and validation failures.

## Endpoints

- `GET /health`
- `GET|POST /api/v1/tickets`
- `GET|PATCH /api/v1/tickets/:id`
- `POST /api/v1/tickets/:id/link_known_issues`
- `GET|POST /api/v1/known_issues`
- `GET|POST /api/v1/glossary_terms`

Authentication and real Zendesk/Jira integrations are intentionally outside the demo scope.
