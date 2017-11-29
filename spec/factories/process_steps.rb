# frozen_string_literal: true

FactoryGirl.define do
  factory :process_step do
    name 'Step1'
    pipeline
    position 1
  end
end
