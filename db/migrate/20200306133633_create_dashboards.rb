# frozen_string_literal: true

class CreateDashboards < ActiveRecord::Migration[6.0]
  def change
    create_table :dashboards do |t|
      t.integer :user_id, null: false

      t.timestamps
    end

    add_foreign_key :dashboards, :users
  end
end
