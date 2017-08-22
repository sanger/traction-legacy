# frozen_string_literal: true

unless Rails.env.production?
  require 'factory_girl'

  namespace :work_orders do
    desc 'create some work orders'
    task create: :environment do |_t|
      FactoryGirl.create_list(:work_order, 5)
      FactoryGirl.create_list(:work_order_with_qc_fail, 5)
      FactoryGirl.create_list(:work_order_for_library_preparation, 5)
      FactoryGirl.create_list(:work_order_for_sequencing, 5)
    end
  end
end
