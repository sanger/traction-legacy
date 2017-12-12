# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order_requirement do
    value 'test'
    requirement
    work_order
  end
end
