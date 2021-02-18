Rails.application.routes.draw do
  root 'static_pages#home'
  resources :issues
  resources :lobbyists
  resources :beliefs
  resources :bills
  resources :representatives
  resources :offices
  resources :email_templates
  devise_for :admins, :skip => [:registrations]
  get '/admins' => 'admins#portal'
  post '/', to: 'representatives#find'
  get '/representatives/:id/:partial' => 'representatives#show', :as => 'show_representative'
  post '/representatives/:id/contact', to: 'representatives#contact'
end
