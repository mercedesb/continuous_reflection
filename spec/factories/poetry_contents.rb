# frozen_string_literal: true

FactoryBot.define do
  factory :poetry_content do
    title { Faker::Lorem.sentence(word_count: 3) }
    poem { Faker::Lorem.paragraph(sentence_count: 2) }

    trait :with_entry do
      after(:build) do |content|
        content.journal_entry = build(:journal_entry, :poetry, content: content)
      end
    end
  end
end
