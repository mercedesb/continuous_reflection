# frozen_string_literal: true

class ProfessionalDevelopmentContent < ApplicationRecord
  module Mood
    CHEERFUL = "cheerful"
    HOPEFUL = "hopeful"
    OK = "ok"
    MEH = "meh"
    GLOOMY = "gloomy"
    STRESSED = "stressed"
    ANGRY = "angry"

    def self.all
      [CHEERFUL,
       HOPEFUL,
       OK,
       MEH,
       GLOOMY,
       STRESSED,
       ANGRY]
    end
  end

  has_one :journal_entry, as: :content, validate: true, dependent: :destroy

  validates_presence_of :title
  validates :mood, inclusion: { in: Mood.all }, allow_blank: true

  accepts_nested_attributes_for :journal_entry, allow_destroy: true
end
