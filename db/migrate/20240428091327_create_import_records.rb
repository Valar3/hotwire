# frozen_string_literal: true

class CreateImportRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :import_records do |t|
      t.jsonb :data
      t.string :error_messages, array: true, default: []
      t.references :import, null: false, foreign_key: true
      t.timestamps
    end
  end
end
