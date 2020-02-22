# frozen_string_literal: true

FactoryBot.define do
  factory :journal_entry do
    journal { create(:journal) }
    content { build(JournalEntry::VALID_CONTENT[journal.template].sample.underscore.to_sym) }

    trait :professional_development do
      association :journal, :professional_development
      content { build(:professional_development_content) }
    end

    trait :poetry do
      association :journal, :poetry
      content { build(:poetry_content) }
    end
  end
end
