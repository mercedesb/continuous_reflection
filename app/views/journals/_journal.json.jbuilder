# frozen_string_literal: true

json.id journal.id
json.name journal.name
json.userId journal.user_id
json.createdAt journal.created_at
json.updatedAt journal.updated_at
json.url journal_url(journal, format: :json)
