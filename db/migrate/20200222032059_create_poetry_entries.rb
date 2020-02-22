# frozen_string_literal: true

class CreatePoetryEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :poetry_entries do |t|
      t.string :title, null: false
      t.string :poem, null: false

      t.timestamps
    end
  end
end
