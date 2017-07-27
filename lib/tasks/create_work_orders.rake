# frozen_string_literal: true

unless Rails.env.staging? || Rails.env.production?
  require 'factory_girl'

  namespace :work_orders do
    desc 'create some work orders'
    task create: :environment do |_t|
      FactoryGirl.create_list(:work_order, 5)
    end
  end
end
