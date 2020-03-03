# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'home#index'

  defaults format: :json do
    get '/home/index', to: 'home#index'
    resources :poetry_contents
    resources :journal_entries
    resources :professional_development_contents
    resources :journals
    resources :users
    get '/options/mood', to: 'options#mood'
  end

  get '/auth/github', to: 'authentication#github', format: false
end
