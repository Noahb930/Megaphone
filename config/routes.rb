Rails.application.routes.draw do
  root 'static_pages#home'
  resources :issues
  resources :lobbyists
  resources :beliefs
  resources :bills
  resources :representatives
  resources :offices
  resources :templates
  devise_for :admins, :skip => [:registrations] 
  get '/admins' => 'admins#portal'
  post '/', to: 'representatives#find'
  get '/representatives/:id/:partial' => 'representatives#show', :as => 'show_representative'
  get '/representatives/us-senate', to: 'representatives#us_senate_index'
  get '/representatives/us-house', to: 'representatives#us_house_index'
  get '/representatives/ny-senate', to: 'representatives#ny_senate_index'
  get '/representatives/ny-assembly', to: 'representatives#ny_assembly_index'
  get '/representatives/nyc-council', to: 'representatives#nyc_council_index'
  end
