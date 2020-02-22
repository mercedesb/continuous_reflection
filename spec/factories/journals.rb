# frozen_string_literal: true

FactoryBot.define do
  factory :journal do
    user
    name { Faker::Lorem.word }
    template { Journal::Template.all.sample }

    trait :professional_development do
      template { Journal::Template::PROFESSIONAL_DEVELOPMENT }
    end

    trait :poetry do
      template { Journal::Template::POETRY }
    end
  end
end
