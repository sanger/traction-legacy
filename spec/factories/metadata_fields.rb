# frozen_string_literal: true

FactoryGirl.define do
  factory :metadata_field do
    name 'Field1'
    required false
    type ''
    process_step
  end
end
