# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  defaults format: :json do
    root to: 'home#index'
    get '/home/index', to: 'home#index'
    get '/home/journal_entries', to: 'home#journal_entries'
    resources :dashboards
    resources :dashboard_components
    resources :poetry_contents
    resources :journal_entries
    resources :professional_development_contents
    resources :journals
    resources :users
    get '/options/mood', to: 'options#mood'
  end

  get '/auth/github', to: 'authentication#github', format: false
end
