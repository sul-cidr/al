Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :authors
  resources :areas
  resources :places, only: [:index]
  resources :categories, only: [:index]
  resources :works
  resources :passages

  root to: "application#index"

  # match ':controller(/:action(/:id))', :via => :get



end
