# frozen_string_literal: true

class CreateQuotes < ActiveRecord::Migration[7.0]
  def change
    create_table :quotes do |t|
      t.string :author, null: false
      t.text :content, null: false
      t.timestamps
    end
  end
end
