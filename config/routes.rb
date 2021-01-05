Rails.application.routes.draw do
  root 'static_pages#home'
  get '/representatives/us-senate', to: 'representatives#us_senate_index'
  get '/representatives/us-house', to: 'representatives#us_house_index'
  get '/representatives/ny-senate', to: 'representatives#ny_senate_index'
  get '/representatives/ny-assembly', to: 'representatives#ny_assembly_index'
  get '/representatives/nyc-council', to: 'representatives#nyc_council_index'
  get '/representatives/:id/edit' => 'representatives#edit', :as => 'edit_representative'
  get '/offices/:id/edit' => 'offices#edit', :as => 'edit_office'
  get '/beliefs/:id/edit' => 'beliefs#edit', :as => 'edit_belief'
  get '/beliefs/new' => 'beliefs#new', :as => 'new_belief'

  resources :initiatives
  resources :issues
  resources :lobbyists
  resources :beliefs
  resources :bills
  resources :representatives
  resources :offices
  resources :emails

  post '/find', to: 'representatives#find'
  get '/representatives/:id/:partial' => 'representatives#show', :as => 'show_representative'
end
