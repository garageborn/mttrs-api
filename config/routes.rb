require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :stories, only: [:index]

  mount Sidekiq::Web => '/sidekiq'
end
