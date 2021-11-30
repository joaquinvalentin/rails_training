# frozen_string_literal: true

Rails.application.routes.draw do
  ActiveAdmin.routes(self)
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Api definition
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: %i[show create update destroy]
      resources :tokens, only: %i[create]
      resources :products, only: %i[index show create update destroy]
    end
  end
end
