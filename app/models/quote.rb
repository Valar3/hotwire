# frozen_string_literal: true

class Quote < ApplicationRecord
  validates :author, presence: true
  validates :content, presence: true
end
