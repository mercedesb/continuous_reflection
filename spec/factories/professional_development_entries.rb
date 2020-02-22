# frozen_string_literal: true

FactoryBot.define do
  factory :professional_development_entry do
    title { Faker::Lorem.sentence(word_count: 3) }
    mood { ProfessionalDevelopmentEntry::Mood.all.sample }
    today_i_learned { Faker::Lorem.paragraph(sentence_count: 2) }
    goal_progress { Faker::Lorem.paragraph(sentence_count: 2) }
    celebrations { Faker::Lorem.paragraph(sentence_count: 2) }

    after(:build) do |content|
      content.journal_entry = build(:journal_entry, :professional_development, content: content)
    end
  end
end
