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

  belongs_to :dashboard
  has_many :dashboard_component_journals, dependent: :destroy
  has_many :journals, through: :dashboard_component_journals
end
