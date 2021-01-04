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
  get '/representatives/:id/overview' => 'representatives#overview', :as => 'overview_representative'
  get '/representatives/:id/beliefs' => 'representatives#beliefs', :as => 'beliefs_representative'
  get '/representatives/:id/votes' => 'representatives#votes', :as => 'votes_representative'
  get '/representatives/:id/contributions' => 'representatives#contributions', :as => 'contributions_representative'
  get '/representatives/:id/contact' => 'representatives#contact', :as => 'contact_representative'
  get '/representatives/:id/admin-overview' => 'representatives#admin_overview', :as => 'admin_overview_representative'
  get '/representatives/:id/admin-beliefs' => 'representatives#admin_beliefs', :as => 'admin_beliefs_representative'
  get '/representatives/:id/admin-votes' => 'representatives#admin_votes', :as => 'admin_votes_representative'
  get '/representatives/:id/admin-contributions' => 'representatives#admin_contributions', :as => 'admin_contributions_representative'
  get '/representatives/:id/admin-contact' => 'representatives#admin_contact', :as => 'admin_contact_representative'

end
