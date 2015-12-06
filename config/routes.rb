Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  resources :authors, param: :author_id
  resources :areas
  resources :places, param: :place_id
  resources :placerefs, param: :placeref_id
  resources :categories#, only: [:index]
  resources :works, param: :work_id
  resources :passages, param: :passage_id
  # resources :passages/search, param: :q
  resources :search, only: [:index]

  root to: "application#index"

end
