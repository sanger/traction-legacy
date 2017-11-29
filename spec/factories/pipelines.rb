# frozen_string_literal: true

FactoryGirl.define do
  factory :pipeline do
    name 'Pipeline1'

    factory :standard_pipeline do
      after(:create) do |pipeline|
        pipeline.process_steps.create!(name: 'started', position: 1)
        pipeline.process_steps.create!(name: 'sequencing', position: 10)
      end
    end
  end
end
