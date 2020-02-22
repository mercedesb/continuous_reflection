# frozen_string_literal: true

class PoetryEntry < ApplicationRecord
  validates_presence_of :title, :poem
end
