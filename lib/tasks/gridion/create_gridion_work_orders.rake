# frozen_string_literal: true

unless Rails.env.production?
  require 'factory_girl'

  namespace :gridion_work_orders do
    desc 'create some work orders'
    task create: :environment do |_t|
      FactoryGirl.create_list(:gridion_work_order, 10)
      FactoryGirl.create_list(:gridion_work_order_ready_for_library_preparation, 5)
      FactoryGirl.create_list(:gridion_work_order_ready_for_sequencing, 5)
    end
  end
end
