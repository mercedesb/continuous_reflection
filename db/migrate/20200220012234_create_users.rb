# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :name, null: false

      t.timestamps
    end
    add_index :users, :username, unique: true
  end
end
