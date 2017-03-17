require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :publishers, only: [:index, :show]
  resources :stories, only: [:index]
  match '/graphql' => 'graphql#create', via: [:get, :post]

  namespace :admin do
    root to: redirect("/admin/#{ Apartment.tenant_names.first }")

    Sidekiq::Web.use(Rack::Auth::Basic) { |username, password| Auth.call(username, password) }
    mount Sidekiq::Web => '/sidekiq'
    mount GraphiQL::Rails::Engine => '/graphql', graphql_path: '/graphql'

    scope '/:tenant_name' do
      get '/', to: 'stories#index'
      resources :categories, except: :show
      resources :category_matchers, except: :show
      resources :links, except: :show do
        get :uncategorized, on: :collection
        get :similar, on: :collection
      end
      resources :publishers, except: :show
      resources :publisher_suggestions, except: :show
      resources :stories, only: %i(index edit update destroy) do
        get :similar_links, on: :member
      end
      get '/elastic', to: 'elastic#index'
    end
  end
end
