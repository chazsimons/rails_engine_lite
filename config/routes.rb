Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      resources :merchants do
        resources :items, controller: 'merchant_items'
      end
      get '/items/find_all', to: 'items#find_all'
      resources :items do
        resources :merchant, controller: 'merchant_items', action: :show
      end
    end
  end
end
