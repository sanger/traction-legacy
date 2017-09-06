# frozen_string_literal: true

FactoryGirl.define do
  factory :printer do
    sequence(:name) { |n| "printer#{n}" }
  end
end
