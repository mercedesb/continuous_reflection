# frozen_string_literal: true

json.extract! poetry_entry, :id, :title, :poem, :created_at, :updated_at
json.url poetry_entry_url(poetry_entry, format: :json)
