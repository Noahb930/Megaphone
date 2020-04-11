Rails.application.routes.draw do
  resources :initiatives
  resources :issues
  resources :lobbyists
  resources :bills
  resources :representatives
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
