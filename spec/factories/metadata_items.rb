# frozen_string_literal: true

FactoryGirl.define do
  factory :metadata_item do
    value 'Value'
    metadata_field
    lab_event
  end
end
