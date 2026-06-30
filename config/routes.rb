Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # root "home#index"

  namespace :api do
    namespace :v1 do
      resources :character_classes, only: [ :index, :show ]
      resources :subclasses, only: [ :index, :show ]
      resources :races, only: [ :index, :show ]
      resources :subraces, only: [ :index, :show ]
      resources :languages, only: [ :index, :show ]

      resources :users, only: [ :index, :show, :create, :update, :destroy ] do
        resources :characters, only: [ :index, :create ], controller: "users/characters"
      end

      resources :characters, only: [ :index, :show, :update, :destroy ]

      # Auth
      post "login", to: "sessions#create"
      delete "logout", to: "sessions#destroy"
      get "current", to: "sessions#current"
    end
  end
end
