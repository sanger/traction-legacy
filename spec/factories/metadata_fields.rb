# frozen_string_literal: true

FactoryGirl.define do
  factory :metadata_field do
    name 'Field1'
    required false
    data_type ''
    process_step

    factory :required_metadata_field do
      required true
    end
  end
end
