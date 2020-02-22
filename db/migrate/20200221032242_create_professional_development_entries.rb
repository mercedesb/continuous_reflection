# frozen_string_literal: true

class CreateProfessionalDevelopmentEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :professional_development_entries do |t|
      t.string :title, null: false
      t.string :mood
      t.string :today_i_learned
      t.string :goal_progress
      t.string :celebrations

      t.timestamps
    end
  end
end
