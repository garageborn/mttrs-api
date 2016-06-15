require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :publishers, only: [:index]
  resources :stories, only: [:index]

  mount Sidekiq::Web => '/sidekiq'
end
