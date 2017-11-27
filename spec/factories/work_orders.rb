# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order do
    aliquot

    sequence(:sequencescape_id)
    study_uuid { SecureRandom.uuid }
    sample_uuid { SecureRandom.uuid }

    factory :gridion_work_order do
      transient do
        number_of_flowcells 3
        library_preparation_type 'rapid'
        data_type 'data_type'
      end

      after(:create) do |work_order, evaluator|
        work_order.details = { 'number_of_flowcells' => evaluator.number_of_flowcells,
                               'library_preparation_type' => evaluator.library_preparation_type,
                               'data_type' => evaluator.data_type }
      end
    end
  end
end
