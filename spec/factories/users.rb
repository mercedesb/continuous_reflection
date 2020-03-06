# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { "#{Faker::Name.last_name}_#{SecureRandom.uuid}" }
    name { Faker::Name.name }
  end
end
