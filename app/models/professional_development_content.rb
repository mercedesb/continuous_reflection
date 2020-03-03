# frozen_string_literal: true

class ProfessionalDevelopmentContent < ApplicationRecord
  # 5 Universal Emotions - Enjoyment, Anger, Sadness, Disgust, Fear
  module Mood
    HAPPY = "happy"
    ANGRY = "angry"
    GLOOMY = "gloomy"
    DISAPPOINTED = "disappointed"
    ANXIOUS = "anxious"

    # This allows for backwards compatibility if the options change in the future
    # Add all possible past and present options to this array for validation
    # Only add what you want users to choose from to options
    def self.all
      [
        HAPPY,
        DISAPPOINTED,
        GLOOMY,
        ANXIOUS,
        ANGRY
      ]
    end

    def self.options
      {
        HAPPY => 5,
        DISAPPOINTED => 4,
        GLOOMY => 3,
        ANXIOUS => 2,
        ANGRY => 1
      }
    end
  end

  has_one :journal_entry, as: :content, validate: true, dependent: :destroy

  validates_presence_of :title
  validates :mood, inclusion: { in: Mood.all }, allow_blank: true

  accepts_nested_attributes_for :journal_entry, allow_destroy: true
end
