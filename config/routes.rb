require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: %i[index show]
  resources :publishers, only: %i[index show]
  resources :stories, only: [:index]
  match '/graphql' => 'graphql#create', via: %i[get post]

  namespace :admin do
    root to: redirect("/admin/#{ Apartment.tenant_names.first }")

    Sidekiq::Web.use(Rack::Auth::Basic) { |username, password| Auth.call(username, password) }
    mount Sidekiq::Web => '/sidekiq'

    scope '/:tenant_name' do
      mount GraphiQL::Rails::Engine => '/graphql', graphql_path: '/graphql'
      get '/', to: 'stories#index'
      resources :categories, except: :show
      resources :category_matchers, except: :show
      resources :links, except: :show do
        get :uncategorized, on: :collection
        get :untagged, on: :collection
        get :similar, on: :collection
      end
      resources :notifications, except: :show
      resources :publishers, except: :show
      resources :publisher_suggestions, except: :show
      resources :stories, only: %i[index edit update destroy] do
        get :similar_links, on: :member
      end
      resources :tags, except: :show
      resources :tag_matchers, except: :show
      get '/elastic', to: 'elastic#index'
    end
  end
end
