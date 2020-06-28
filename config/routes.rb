Rails.application.routes.draw do
  root 'static_pages#home'
  resources :initiatives
  resources :issues
  resources :lobbyists
  resources :bills
  resources :representatives
  post '/find', to: 'representatives#find'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
