# frozen_string_literal: true

class CreateJournals < ActiveRecord::Migration[6.0]
  def change
    create_table :journals do |t|
      t.string :name, null: false
      t.integer :user_id, null: false
      t.timestamps
    end

    add_foreign_key :journals, :users
  end
end
