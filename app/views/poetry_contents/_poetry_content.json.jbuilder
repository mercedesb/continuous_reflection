# frozen_string_literal: true

json.extract! poetry_content, :id, :title, :poem
json.journalEntryId poetry_content.journal_entry.id
json.createdAt poetry_content.created_at
json.updatedAt poetry_content.updated_at
json.url poetry_content_url(poetry_content, format: :json)
