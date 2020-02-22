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

  validates_presence_of :title
  validates :mood, inclusion: { in: Mood.all }
end
