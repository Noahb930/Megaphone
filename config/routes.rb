Rails.application.routes.draw do
  root 'representatives#find'
  resources :issues
  resources :lobbyists
  resources :beliefs
  resources :bills
  resources :representatives
  resources :offices
  resources :email_templates
  devise_for :admins, :skip => [:registrations]
  get '/about' => 'static_pages#about'
  get '/implement' => 'static_pages#implement'
  get '/faq' => 'static_pages#faq'
  get '/feedback' => 'static_pages#feedback'
  post '/feedback', to: 'static_pages#email'
  get '/admins' => 'admins#portal'
  post '/', to: 'representatives#location_specific'
  get '/representatives/:id/:partial' => 'representatives#show', :as => 'show_representative'
  post '/representatives/:id/contact', to: 'representatives#contact'
end
