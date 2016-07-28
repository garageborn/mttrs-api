require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :publishers, only: [:index]
  resources :stories, only: [:index]

  namespace :admin do
    root to: redirect('/admin/stories')
    resources :categories, except: :show
    resources :category_matchers, except: :show
    resources :feeds, except: :show
    resources :links, except: :show do
      put :remove_from_story, on: :member
    end
    resources :publishers, except: :show
    resources :stories, except: :show
    get '/elastic', to: 'elastic#index'

    Sidekiq::Web.use(Rack::Auth::Basic) { |username, password| Auth.call(username, password) }
    mount Sidekiq::Web => '/sidekiq'
  end
end
