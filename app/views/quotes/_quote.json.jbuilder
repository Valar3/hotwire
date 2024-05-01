# frozen_string_literal: true

json.extract! quote, :id, :created_at, :updated_at
json.url quote_url(quote, format: :json)
