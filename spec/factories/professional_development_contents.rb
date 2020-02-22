# frozen_string_literal: true

FactoryBot.define do
  factory :professional_development_content do
    title { Faker::Lorem.sentence(word_count: 3) }
    mood { ProfessionalDevelopmentContent::Mood.all.sample }
    today_i_learned { Faker::Lorem.paragraph(sentence_count: 2) }
    goal_progress { Faker::Lorem.paragraph(sentence_count: 2) }
    celebrations { Faker::Lorem.paragraph(sentence_count: 2) }

    trait :with_entry do
      after(:build) do |content|
        content.journal_entry = build(:journal_entry, :professional_development, content: content)
      end
    end
  end
end
