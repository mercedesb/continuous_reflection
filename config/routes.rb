# frozen_string_literal: true

Rails.application.routes.draw do
  resources :poetry_entries
  resources :journal_entries
  resources :professional_development_entries
  resources :journals
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  defaults format: :json do
    resources :home, only: [:index]
  end

  get '/auth/github', to: 'authentication#github', format: false
end
