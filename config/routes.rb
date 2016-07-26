require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :publishers, only: [:index]
  resources :stories, only: [:index]

  namespace :admin do
    root to: redirect('/admin/stories')
    resources :categories
    resources :category_matchers
    resources :feeds
    resources :publishers
    resources :stories
    get '/elastic', to: 'elastic#index'

    Sidekiq::Web.use(Rack::Auth::Basic) { |username, password| Auth.call(username, password) }
    mount Sidekiq::Web => '/sidekiq'
  end
end
