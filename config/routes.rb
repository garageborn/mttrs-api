require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :publishers, only: [:index]
  resources :stories, only: [:index]

  get '/elastic', to: 'elastic#index'

  mount Sidekiq::Web => '/sidekiq'
end
