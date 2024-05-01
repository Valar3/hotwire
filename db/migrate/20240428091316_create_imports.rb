# frozen_string_literal: true

class CreateImports < ActiveRecord::Migration[7.0]
  def change
    create_table :imports do |t|
      t.string :file_data, null: false
      t.integer :error_count, default: 0
      t.timestamps
    end
  end
end
