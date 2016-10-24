require 'sidekiq/web'

Rails.application.routes.draw do
  resources :categories, only: [:index, :show]
  resources :publishers, only: [:index, :show]
  resources :stories, only: [:index]
  resources :graphql, via: [:post, :options]

  namespace :admin do
    root to: redirect("/admin/#{ Apartment.tenant_names.first }")

    Sidekiq::Web.use(Rack::Auth::Basic) { |username, password| Auth.call(username, password) }
    mount Sidekiq::Web => '/sidekiq'
    mount GraphiQL::Rails::Engine => '/graphql', graphql_path: '/graphql'

    scope '/:tenant_name' do
      get '/', to: 'stories#index'
      resources :categories, except: :show
      resources :category_matchers, except: :show
      resources :feeds, except: :show
      resources :links, except: :show do
        get :uncategorized, on: :collection
        put :remove_from_story, on: :member
      end
      resources :publishers, except: :show
      resources :stories, only: %i(index edit update destroy)
      get '/elastic', to: 'elastic#index'
    end
  end
end
