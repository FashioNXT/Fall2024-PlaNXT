# frozen_string_literal: true

Rails.application.routes.draw do
  # Favicon route to prevent errors
  get '/favicon.ico', to: proc { [204, {}, []] }
  
  resources :items do
    collection do
      get :search # Defines a route for the search action on items controller.
      #get :fetch_all # New route to fetch all items
    end
    member do
      get :dependencies
    end
  end

  # Not sure if this is right, need to reconcile with how you did it -Louis
  get 'plans/:id/preview3d', to: 'plans#preview3d'

  resources :steps
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root 'home#index'

  get 'blueprints', to: 'blueprints#index'

  resources :plans do
    # collection do
    #   get 'plans', to:'plans#user_plans'
    # end
    member do
      get 'floorplans2d'
    end
  end

  # config/routes.rb

  # resources :plans do
  # collection do
  #  get 'download_all_data'
  # end
  # end

  resources :plans do
    member do
      post 'upload_existing_plan'
    end
  end

  get 'download_all_data', to: 'plans#download_all_data', as: 'download_all_data'

  # config/routes.rb
  post '/upload_existing_plan', to: 'plans#upload_existing_plan' # Defines a route for the upload_existing_plan action on plans controller.

  # user sign up and login
  get '/auth/events360/callback', to: 'sessions#create'
  get 'sessions', to: 'sessions#create'
  get 'sign_in', to: 'sessions#new'
  delete '/logout', to: 'sessions#destroy'
end
