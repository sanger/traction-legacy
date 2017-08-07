# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :work_orders
  resources :receptions, only: [:index]

  root 'work_orders#index'
end
