# frozen_string_literal: true

class ProfessionalDevelopmentEntry < ApplicationRecord
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
  validates_presence_of :journal_entry, message: "journal can't be blank"
  validates :mood, inclusion: { in: Mood.all }, allow_nil: true

  accepts_nested_attributes_for :journal_entry, allow_destroy: true
end
