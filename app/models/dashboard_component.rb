# frozen_string_literal: true

class DashboardComponent < ApplicationRecord
  module Type
    JOURNAL_CALENDAR = "JournalCalendar"
    MOOD_OVER_TIME = "MoodOverTime"

    def self.all
      [JOURNAL_CALENDAR,
       MOOD_OVER_TIME]
    end
  end

  validates_presence_of :component_type, :position
  validates :component_type, inclusion: { in: Type.all }
  validate :journal_has_moods, if: -> { component_type == Type::MOOD_OVER_TIME }

  belongs_to :dashboard
  belongs_to :journal

  JOURNALS_WITH_MOOD = [Journal::Template::PROFESSIONAL_DEVELOPMENT].freeze

  def journal_has_moods
    if journal.present?
      errors.add(:component_type, "cannot use the MoodOverTime component with #{journal.template} journal") unless JOURNALS_WITH_MOOD.include?(journal.template)
    end
  end
end
