# frozen_string_literal: true

FactoryBot.define do
  factory :poetry_entry do
    title { Faker::Lorem.sentence(word_count: 3) }
    poem { Faker::Lorem.paragraph(sentence_count: 2) }
  end
end
