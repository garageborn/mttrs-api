Rails.application.routes.draw do
  resources :categories, only: [:index]
  resources :stories, only: [:index]
end
