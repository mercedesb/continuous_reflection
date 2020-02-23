# frozen_string_literal: true

json.extract! user, :id, :username, :name
json.createdAt user.created_at
json.updatedAt user.updated_at
json.url user_url(user, format: :json)
