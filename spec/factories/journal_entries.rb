# frozen_string_literal: true

FactoryBot.define do
  factory :journal_entry do
    association :journal, :professional_development
    content { build(:professional_development_content) }

    trait :professional_development do
      association :journal, :professional_development
      content { build(:professional_development_content) }
    end

    trait :poetry do
      association :journal, :poetry
      content { build(:poetry_entry) }
    end
  end
end
