# frozen_string_literal: true

class OptionsController < ApplicationController
  def mood
    @moods = ProfessionalDevelopmentContent::Mood.all
  end
end
