# frozen_string_literal: true

class CreateDashboardComponentJournals < ActiveRecord::Migration[6.0]
  def change
    create_table :dashboard_component_journals do |t|
      t.integer :dashboard_component_id, null: false
      t.integer :journal_id, null: false
    end

    add_foreign_key :dashboard_component_journals, :dashboard_components
    add_foreign_key :dashboard_component_journals, :journals
  end
end
