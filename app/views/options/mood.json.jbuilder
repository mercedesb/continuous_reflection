# frozen_string_literal: true

json.array! @moods do |mood_name, mood_ranking|
  json.label mood_name.titleize
  json.value mood_name
  json.ranking mood_ranking
end
