Rails.application.routes.draw do
  root 'static_pages#home'
  resources :initiatives
  resources :issues
  resources :lobbyists
  resources :bills
  resources :representatives
  post '/find', to: 'representatives#find'
  get '/partials/overview' => 'representatives#overview', :as => 'overview_representative'
  get '/partials/beliefs' => 'representatives#beliefs', :as => 'beliefs_representative'
  get '/partials/votes' => 'representatives#votes', :as => 'votes_representative'
  get '/partials/contributions' => 'representatives#contributions', :as => 'contributions_representative'
  get '/partials/contact' => 'representatives#contact', :as => 'contact_representative'
end
