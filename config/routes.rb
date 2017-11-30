# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :pipelines, only: [:index] do
    resources :work_orders, only: %i[index show] do
      resources :lab_processes
    end
    get 'reception', to: 'reception#index'
    post 'reception/upload', to: 'reception#upload'
    resources :sequencing_runs
  end

  resources :print_jobs, only: %i[create]

  match 'test_exception_notifier', controller: 'application',
                                   action: 'test_exception_notifier', via: :get

  # think about root
  root 'pipelines#index'
end
