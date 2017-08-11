# frozen_string_literal: true

FactoryGirl.define do
  factory :library do
    work_order

    sequence(:kit_number) { |n| "KIT-#{n}" }
    volume 0.03
  end
end
