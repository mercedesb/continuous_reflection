# frozen_string_literal: true

class CreateDashboardComponents < ActiveRecord::Migration[6.0]
  def change
    create_table :dashboard_components do |t|
      t.integer :dashboard_id, null: false
      t.string :component_type, null: false
      t.integer :position, null: false
      t.timestamps
    end

    add_foreign_key :dashboard_components, :dashboards
  end
end
