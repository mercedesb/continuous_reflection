# frozen_string_literal: true

class RenameProfessionalDevelopmentEntryToProfessionalDevelopmentContent < ActiveRecord::Migration[6.0]
  def self.up
    rename_table :professional_development_entries, :professional_development_contents
  end

  def self.down
    rename_table :professional_development_contents, :professional_development_entries
  end
end
