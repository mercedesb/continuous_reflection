# frozen_string_literal: true

class Journal < ApplicationRecord
  module Template
    PROFESSIONAL_DEVELOPMENT = "Professional Development"
    POETRY = "Poetry"

    def self.all
      [PROFESSIONAL_DEVELOPMENT,
       POETRY]
    end
  end

  belongs_to :user
  has_many :journal_entries, dependent: :destroy

  validates_presence_of :name, :template
  validates :template, inclusion: { in: Template.all }
end
