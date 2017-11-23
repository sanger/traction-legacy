# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :work_orders, only: %i[index show]
  resources :sequencing_runs

  get 'reception', to: 'reception#index'
  post 'reception/upload', to: 'reception#upload'

  resources :print_jobs, only: %i[create]

  match 'test_exception_notifier', controller: 'application',
                                   action: 'test_exception_notifier', via: :get

  root 'work_orders#index'
end
