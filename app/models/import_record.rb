# frozen_string_literal: true

class ImportRecord < ApplicationRecord
  belongs_to :import
    after_update_commit { broadcast_replace_to "import_record" }
end
