# frozen_string_literal: true

Rails.application.routes.draw do
  resources :quotes
  resources :imports do
    post :import, on: :member
    resources :import_records
  end
end
