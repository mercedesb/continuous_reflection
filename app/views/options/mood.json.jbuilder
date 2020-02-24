# frozen_string_literal: true

json.array! @moods do |mood|
  json.label mood.titleize
  json.value mood
end
