# frozen_string_literal: true

class PoetryContent < ApplicationRecord
  has_one :journal_entry, as: :content, validate: true, dependent: :destroy

  validates_presence_of :title, :poem

  accepts_nested_attributes_for :journal_entry, allow_destroy: true
end
