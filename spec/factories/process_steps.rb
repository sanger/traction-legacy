# frozen_string_literal: true

FactoryGirl.define do
  factory :process_step do
    name 'Step1'
    pipeline
    position 1

    factory :process_step_with_metadata_fields do
      after(:create) do |process_step|
        create_list(:metadata_field, 3, process_step: process_step)
      end
    end
  end
end
