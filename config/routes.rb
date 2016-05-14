Rails.application.routes.draw do
  resources :links, only: [:index]
end
