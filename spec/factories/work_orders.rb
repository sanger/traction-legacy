# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order do
    aliquot

    sequence(:sequencescape_id)
    study_uuid { SecureRandom.uuid }
    sample_uuid { SecureRandom.uuid }

  end
end
