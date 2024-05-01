# frozen_string_literal: true

class ImportUploader < Shrine
  Attacher.validate do
    validate_extension %w[xlsx xls ods]
  end
end
