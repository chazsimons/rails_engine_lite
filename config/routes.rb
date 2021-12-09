Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/merchants/find_all', to: 'merchants#find_all'
      resources :merchants do
        resources :items, controller: 'merchant_items', action: :index
      end
      get '/items/find_all', to: 'items#find_all'
      get '/items/find',     to: 'items#find'
      resources :items do
        resources :merchant, controller: 'merchant_items', action: :show
      end
    end
  end
end
