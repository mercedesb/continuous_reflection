# frozen_string_literal: true

class AddEntryDateToJournalEntry < ActiveRecord::Migration[6.0]
  def change
    add_column :journal_entries, :entry_date, :date, null: false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
