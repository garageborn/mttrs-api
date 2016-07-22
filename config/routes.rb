require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :publishers, only: [:index]
  resources :stories, only: [:index]

  namespace :admin do
    resources :stories
    get '/elastic', to: 'elastic#index'
  end

  mount Sidekiq::Web => '/sidekiq'
end
