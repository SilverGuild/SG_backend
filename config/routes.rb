Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "home#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :index, :show, :create, :update, :destroy ]
      resources :characters, only: [ :index, :show, :create, :update, :destroy ]
      resources :character_classes, only: [ :index, :show ]
      resources :races, only: [ :index, :show ]
      resources :languages, only: [ :index, :show ]
    end
  end
end
