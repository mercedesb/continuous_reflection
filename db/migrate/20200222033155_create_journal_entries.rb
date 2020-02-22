# frozen_string_literal: true

class CreateJournalEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :journal_entries do |t|
      t.integer :journal_id, null: false
      t.string :content_type, null: false
      t.integer :content_id, null: false

      t.timestamps
    end

    add_foreign_key :journal_entries, :journals
  end
end
