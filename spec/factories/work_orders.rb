# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order do
    aliquot

    uuid { SecureRandom.uuid }
  end
end
