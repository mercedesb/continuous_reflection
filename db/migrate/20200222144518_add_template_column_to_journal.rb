# frozen_string_literal: true

class AddTemplateColumnToJournal < ActiveRecord::Migration[6.0]
  def change
    add_column :journals, :template, :string, null: false
  end
end
