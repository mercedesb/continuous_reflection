# frozen_string_literal: true

json.extract! poetry_content, :id, :title, :poem, :created_at, :updated_at
json.url poetry_content_url(poetry_content, format: :json)
