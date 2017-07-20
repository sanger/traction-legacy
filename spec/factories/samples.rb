# frozen_string_literal: true

FactoryGirl.define do
  factory :sample do
    sequence(:name) { |n| "SAMPLE-#{n}" }
    uuid { SecureRandom.uuid }
    # tube

    # factory :sample_after_qc do
    #   concentration 0.005
    #   fragment_size 500
    #   qc_state 'proceed'
    # end
  end
end
