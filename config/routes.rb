Rails.application.routes.draw do
  resources :stories, only: [:index]
end
