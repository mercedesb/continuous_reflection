# frozen_string_literal: true

class PoetryEntry < ApplicationRecord
  has_one :journal_entry, as: :content, validate: true, dependent: :destroy

  validates_presence_of :title, :poem
  validates_presence_of :journal_entry, message: "journal can't be blank"

  accepts_nested_attributes_for :journal_entry, allow_destroy: true
end
