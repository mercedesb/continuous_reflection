# frozen_string_literal: true

class RenamePoetryEntryToPoetryContent < ActiveRecord::Migration[6.0]
  def self.up
    rename_table :poetry_entries, :poetry_contents
  end

  def self.down
    rename_table :poetry_contents, :poetry_entries
  end
end
