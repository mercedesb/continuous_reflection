# frozen_string_literal: true

class RenameProfessionalDevelopmentContentToProfessionalDevelopmentContent < ActiveRecord::Migration[6.0]
  def change
    def self.up
      rename_table :professional_development_contents, :professional_development_content
  end

    def self.down
      rename_table :professional_development_content, :professional_development_contents
    end
  end
end
