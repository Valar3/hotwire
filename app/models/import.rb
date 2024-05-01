# frozen_string_literal: true

class Import < ApplicationRecord

  include ImportUploader::Attachment(:file)

  has_many :import_records, dependent: :destroy
end
