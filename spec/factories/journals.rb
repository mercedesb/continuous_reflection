# frozen_string_literal: true

FactoryBot.define do
  factory :journal do
    user
    name { Faker::Lorem.word }
  end
end
