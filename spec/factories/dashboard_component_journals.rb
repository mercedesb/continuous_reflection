# frozen_string_literal: true

FactoryBot.define do
  factory :dashboard_component_journal do
    journal
    dashboard_component
  end
end
