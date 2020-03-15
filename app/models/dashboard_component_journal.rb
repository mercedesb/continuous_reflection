# frozen_string_literal: true

class DashboardComponentJournal < ApplicationRecord
  validate :journal_has_moods, if: -> { journal.present? && dashboard_component.present? && dashboard_component.component_type == DashboardComponent::Type::MOOD_OVER_TIME }

  belongs_to :dashboard_component
  belongs_to :journal

  JOURNALS_WITH_MOOD = [Journal::Template::PROFESSIONAL_DEVELOPMENT].freeze

  def journal_has_moods
    errors.add(:component_type, "cannot use the MoodOverTime component with #{journal.template} journal") unless JOURNALS_WITH_MOOD.include?(journal.template)
  end
end
