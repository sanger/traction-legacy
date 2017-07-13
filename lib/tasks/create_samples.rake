# frozen_string_literal: true

require 'factory_girl'

namespace :samples do
  desc 'create some samples'
  task create: :environment do |_t|
    FactoryGirl.build_list(:sample, 5).each do |sample|
      Sample.create(name: sample.name)
    end
  end
end
