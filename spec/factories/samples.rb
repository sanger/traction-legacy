# frozen_string_literal: true

FactoryGirl.define do
  factory :sample do
    sequence(:name) { |n| "SAMPLE-#{n}" }
    uuid { SecureRandom.uuid }

    after(:build) do |sample|
      sample.aliquot ||= FactoryGirl.build(:aliquot, sample: sample)
    end
  end
end
