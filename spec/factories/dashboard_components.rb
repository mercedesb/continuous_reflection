# frozen_string_literal: true

FactoryBot.define do
  factory :dashboard_component do
    dashboard
    journal
    component_type { DashboardComponent::Type::JOURNAL_CALENDAR }
    position { 0 }

    trait :journal_calendar do
      component_type { DashboardComponent::Type::JOURNAL_CALENDAR }
    end

    trait :mood_over_time do
      component_type { DashboardComponent::Type::MOOD_OVER_TIME }
    end
  end
end
