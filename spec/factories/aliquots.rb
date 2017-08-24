# frozen_string_literal: true

FactoryGirl.define do
  factory :aliquot do
    sequence(:name) { |n| "DN4914#{n}A:A#{n}"}

    factory :aliquot_proceed do
      concentration 0.005
      fragment_size 500
      qc_state 'proceed'

      factory :aliquot_fail do
        qc_state 'fail'
      end
    end
  end
end
