# SilverGuild — Backend API

The Ruby on Rails API powering **SilverGuild**, a Dungeons & Dragons toolkit for managing user profiles, characters, and interactive character sheets.

This repository is the **backend** only. The Next.js frontend lives in a separate repository within the same organization (see [Related Repositories](#related-repositories)).

> **Project status:** Early development (P1). User profiles and character management are in place; authentication and authorization are planned next. See [Roadmap](#roadmap).

---

## Table of Contents

- [SilverGuild — Backend API](#silverguild--backend-api)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Tech Stack](#tech-stack)
  - [Architecture](#architecture)
    - [Versioned, namespaced API](#versioned-namespaced-api)
    - [Thin local model + live external lookups](#thin-local-model--live-external-lookups)
    - [Integration boundary](#integration-boundary)
  - [Data Model](#data-model)
    - [`users`](#users)
    - [`characters`](#characters)
  - [API Reference](#api-reference)
    - [D\&D reference data (proxied from the 5e API)](#dd-reference-data-proxied-from-the-5e-api)
    - [Users](#users-1)
    - [Characters](#characters-1)
    - [Response shapes](#response-shapes)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Setup](#setup)
  - [Running Tests](#running-tests)
  - [Seeding the Database](#seeding-the-database)
  - [Continuous Integration](#continuous-integration)
  - [Roadmap](#roadmap)
  - [Related Repositories](#related-repositories)
  - [License](#license)

---

## Overview

SilverGuild's backend exposes a versioned JSON API (`/api/v1`) for:

- **Users** — basic profiles that own characters.
- **Characters** — player characters with level, experience, alignment, background, languages, and references to D&D 5e classes, subclasses, races, and subraces.
- **D&D reference data** — classes, subclasses, races, subraces, and languages, served by proxying the public [D&D 5e API](https://www.dnd5eapi.co/) at request time.

A character stored in SilverGuild holds only the lightweight 5e *slugs* (for example `"druid"`, `"gnome"`) for its class and race. Full rules detail is fetched live from the 5e API and wrapped in plain Ruby objects when needed, rather than being duplicated into this database. See [Architecture](#architecture) for the reasoning.

---

## Tech Stack

| Concern | Choice |
| --- | --- |
| Framework | Ruby on Rails `~> 8.1.1` |
| Language | Ruby 3.2+ _(Rails 8.1 minimum; confirm exact version via `.ruby-version`)_ |
| Web server | [Puma](https://github.com/puma/puma) |
| Database | PostgreSQL (`pg ~> 1.6`) |
| Cross-origin | [`rack-cors`](https://github.com/cyu/rack-cors) — for the separate-origin Next.js frontend |
| External data | [D&D 5e API](https://www.dnd5eapi.co/) via [Faraday](https://lostisland.github.io/faraday/) |
| Serialization | [`jsonapi-serializer`](https://github.com/jsonapi-serializer/jsonapi-serializer) (`CharacterSerializer`) |
| Testing | RSpec, shoulda-matchers, FactoryBot, WebMock + VCR, Faker, SimpleCov |
| Static analysis | RuboCop (rails-omakase), Brakeman, bundler-audit |

> This is a standard Rails 8 application, so the default frontend gems (`importmap-rails`, `turbo-rails`, `stimulus-rails`, `sprockets-rails`, `jbuilder`) are present but largely unused — the UI is a separate Next.js app and this backend serves JSON.

---

## Architecture

### Versioned, namespaced API

All endpoints live under `Api::V1` (`/api/v1/...`), leaving room to evolve the contract without breaking existing clients.

### Thin local model + live external lookups

The most important design decision in this codebase: **SilverGuild does not store a local copy of D&D 5e rules content.** A `Character` persists only the slugs that identify its 5e entities:

```ruby
character_class_id: "druid"
race_id:            "gnome"
subclass_id:        "land"
subrace_id:         "rock-gnome"
```

When detailed information about a character's class, subclass, race, subrace, or a language is needed, the model fetches it on demand through a gateway and wraps the response in a plain Ruby object (PORO):

```
Character#race
   └─ Dnd5eDataGateway.fetch_races("gnome")   # Faraday GET https://www.dnd5eapi.co/api/2014/races/gnome
        └─ RacePoro.new(data)                  # lightweight object the rest of the app talks to
```

**Why this approach:**

- The 5e API is the single source of truth for rules content — no sync jobs, no stale copies.
- The local schema stays small and focused on *user-owned* data (characters and their choices).
- The gateway and PORO layer form a clean integration boundary, so the rest of the app never talks to Faraday or raw JSON directly.

**Trade-offs to be aware of:**

- Reads that need full rules detail depend on an external service being reachable. Caching is a likely future optimization (see [Roadmap](#roadmap)).
- The `*_id` columns are slugs, **not** foreign keys to local tables. Only `user_id` is a true foreign key.

### Integration boundary

| Layer | Responsibility |
| --- | --- |
| `Dnd5eDataGateway` | One place that knows how to talk to the 5e API (base URL, endpoints, status handling). |
| `*Poro` objects | Wrap external JSON in stable Ruby objects the domain code can rely on. |
| `Character` model | Owns persistence + validation; delegates rules lookups to the gateway. |
| `Api::V1` controllers | HTTP concerns, parameter handling, error shaping, serialization. |

Cross-origin requests from the Next.js frontend (a different origin) are handled by `rack-cors`; configure allowed origins in `config/initializers/cors.rb`.

---

## Data Model

```
User 1 ──── ∞ Character
```

### `users`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | bigint | Primary key |
| `username` | string | |
| `email` | string | |
| `created_at` / `updated_at` | datetime | |

### `characters`

| Column | Type | Notes |
| --- | --- | --- |
| `id` | bigint | Primary key |
| `user_id` | bigint | **Foreign key → users**, required, indexed |
| `name` | string | Required; unique per user |
| `level` | integer | Required; integer > 0 |
| `experience_points` | integer | Required; integer ≥ 0 |
| `alignment` | string | Required |
| `background` | string | Required |
| `character_class_id` | string | Required; 5e slug, indexed; format `/\A[a-z-]+\z/` |
| `subclass_id` | string | Optional; 5e slug; same format when present |
| `race_id` | string | Required; 5e slug, indexed; same format |
| `subrace_id` | string | Optional; 5e slug; same format when present |
| `languages` | string[] | Postgres array, default `[]`, at least one required |
| `created_at` / `updated_at` | datetime | |

**Validations of note (see `app/models/character.rb`):**

- `name` is unique **scoped to `user_id`** (two different users may have a character with the same name).
- `languages` must be an array of strings with at least one entry.
- Class/race/subclass/subrace slugs must match `/\A[a-z-]+\z/`; subclass and subrace allow blank.

---

## API Reference

Base path: `/api/v1`

### D&D reference data (proxied from the 5e API)

| Method | Path | Description |
| --- | --- | --- |
| GET | `/character_classes` | List classes |
| GET | `/character_classes/:id` | Show one class |
| GET | `/subclasses` | List subclasses |
| GET | `/subclasses/:id` | Show one subclass |
| GET | `/races` | List races |
| GET | `/races/:id` | Show one race |
| GET | `/subraces` | List subraces |
| GET | `/subraces/:id` | Show one subrace |
| GET | `/languages` | List languages |
| GET | `/languages/:id` | Show one language |

### Users

| Method | Path | Description |
| --- | --- | --- |
| GET | `/users` | List users |
| GET | `/users/:id` | Show one user |
| POST | `/users` | Create a user |
| PATCH/PUT | `/users/:id` | Update a user |
| DELETE | `/users/:id` | Delete a user |

### Characters

| Method | Path | Description |
| --- | --- | --- |
| GET | `/users/:user_id/characters` | List a user's characters |
| POST | `/users/:user_id/characters` | Create a character for a user |
| GET | `/characters` | List all characters |
| GET | `/characters/:id` | Show one character |
| PATCH/PUT | `/characters/:id` | Update a character |
| DELETE | `/characters/:id` | Delete a character |

> Character **creation is nested under a user** (`POST /users/:user_id/characters`), handled by `Api::V1::Users::CharactersController`. The top-level `/characters` collection is read/update/delete only.

### Response shapes

**Success** — JSON:API-style envelope:

```json
{
  "data": {
    "id": "2",
    "type": "character",
    "attributes": {
      "name": "Theren Nightblade",
      "level": 5,
      "experience_points": 500,
      "alignment": "Lawful Evil",
      "background": "Aristocrat",
      "user_id": 1,
      "character_class_id": "paladin",
      "race_id": "dragonborn",
      "subclass_id": "devotion",
      "subrace_id": "",
      "languages": ["common", "draconic"]
    }
  }
}
```

**Errors** — a flat `error` message with an appropriate status:

```json
{ "error": "Character not found" }
```

| Status | When |
| --- | --- |
| `400 Bad Request` | Malformed ID, blank required field, or wrong type for a field |
| `404 Not Found` | Target record does not exist |
| `422 Unprocessable Content` | Uniqueness conflict (e.g. duplicate character name for a user) |

---

## Getting Started

### Prerequisites

- Ruby 3.2+ _(Rails 8.1 minimum; confirm exact version via `.ruby-version`)_
- Bundler
- PostgreSQL (running locally)

### Setup

```bash
# 1. Clone
git clone <this-repo-url>
cd <repo>

# 2. Install dependencies
bundle install

# 3. Create and migrate the database
bin/rails db:create
bin/rails db:migrate

# 4. (Optional) Seed sample data
bin/rails db:seed

# 5. Start the server
bin/rails server
```

The API will be available at `http://localhost:3000/api/v1`.

> No external API key is required — the D&D 5e API is public and the base URL is configured in `Dnd5eDataGateway`.

---

## Running Tests

The suite uses RSpec request specs that exercise the API end to end.

```bash
# Full suite
bundle exec rspec

# A single file
bundle exec rspec spec/requests/api/v1/characters_request_spec.rb
```

Specs cover happy and sad paths for character index, show, update, and delete — including ID-format, type, presence, not-found, and uniqueness errors. Authentication/authorization specs are stubbed out pending the auth work (see [Roadmap](#roadmap)).

The test toolchain includes:

- **WebMock + VCR** — outbound calls to the D&D 5e API are stubbed/recorded so specs run offline and deterministically.
- **shoulda-matchers** — concise model validation/association specs.
- **FactoryBot + Faker** — test data factories and realistic fake values.
- **SimpleCov** — coverage reporting.
- **rspec_junit_formatter** — JUnit-format output for CI consumption.

Static analysis is also available locally and in CI:

```bash
bundle exec rubocop                       # style (rails-omakase)
bundle exec brakeman -q -w2               # security scan
bundle exec bundle-audit check --update   # dependency CVE check (refreshes the advisory DB)
```

---

## Seeding the Database

`db/seeds.rb` generates realistic sample data with Faker:

- ~10 users
- 3–8 characters per user, with class/subclass and race/subrace combinations drawn from curated lists and experience points derived from each character's level.

> The seed file **destroys all existing `User` and `Character` records** before inserting samples. It is intended for development only — guard or remove that step before production use.

---

## Continuous Integration

CI runs on **GitHub Actions** for every push to `main` and every pull request, in two jobs:

- **`scan_and_lint`** — RuboCop (rails-omakase rules), Brakeman (static security scan), and `bundle-audit` (dependency CVE check against the Ruby Advisory DB).
- **`test`** — boots PostgreSQL and Redis service containers, loads the schema, runs the full RSpec suite, and uploads the JUnit results as a build artifact.

VCR cassettes are cached between runs, so the 5e API is never called during CI.

> _Hosting is not yet provisioned._ GitHub Actions is CI/CD tooling, not an application host — a runtime (e.g. Render, Fly.io, Heroku, or a managed container/VM) plus a managed PostgreSQL instance will be needed to serve the API publicly. Update this section once a host is chosen.

---

## Roadmap

- [ ] **Authentication** — user sign-in / sessions. `bcrypt` (`has_secure_password`) is scaffolded but commented in the Gemfile, suggesting a built-in/token-based path rather than Devise _(direction to be confirmed)_.
- [ ] **Authorization** — owner vs. Dungeon Master access to characters, planned with **Pundit** (the `pundit-matchers` test gem is already present). The request specs reserve `401` cases for this.
- [ ] **AI-assisted character creation** — let a user describe a character in plain language (e.g. "a cautious dwarf cleric who grew up in a mountain monastery") and have an LLM populate the sheet for them, creating an easy entry point for players new to D&D. Planned shape:
  - A provider-agnostic `LlmGateway`, mirroring the existing `Dnd5eDataGateway` boundary, so the model provider can be swapped without touching domain code.
  - **Constrained output** mapped onto the existing fields: the LLM must return valid 5e slugs (`character_class_id`, `race_id`, …), one of the nine alignments, and a known background, so its suggestions pass the same `Character` validations as manual input.
  - Returns an **editable draft** that the player reviews and confirms before saving, rather than auto-committing — keeping a human in the loop and the persisted data clean.
- [ ] **Caching** for proxied 5e reference data to reduce external calls and add resilience.
- [ ] **Application hosting** + managed PostgreSQL.
- [ ] Expanded character sheet attributes (ability scores, proficiencies, equipment, spells).

---

## Related Repositories

- **Frontend (Next.js):** [SilverGuild/SG_frontend](https://github.com/SilverGuild/SG_frontend) — same organization.

---

## License

Released under the [MIT License](LICENSE). You're free to use, modify, and distribute this code, including commercially, provided the copyright notice is retained.

> Note: the MIT License covers the application code in this repository. D&D 5e rules content is fetched at runtime from the [D&D 5e API](https://www.dnd5eapi.co/) and is not bundled here, so it falls under its own terms rather than this license.