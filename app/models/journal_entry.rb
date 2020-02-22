# frozen_string_literal: true

class JournalEntry < ApplicationRecord
  belongs_to :journal
  belongs_to :content, polymorphic: true

  validate :entry_type_must_match_journal_template

  VALID_CONTENT = {
    Journal::Template::PROFESSIONAL_DEVELOPMENT => [ProfessionalDevelopmentEntry.name],
    Journal::Template::POETRY => [PoetryEntry.name]
  }.freeze

  def entry_type_must_match_journal_template
    if journal.present?
      errors.add(:journal_entry_content_type, "wrong journal entry type") unless VALID_CONTENT[journal.template].include?(content_type)
    end
  end
end
