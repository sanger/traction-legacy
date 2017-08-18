# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order do
    aliquot

    sequence(:sequencescape_id)
    library_preparation_type 'rapid'
    data_type 'basecalls'
    number_of_flowcells 3
    study_uuid { SecureRandom.uuid }
    sample_uuid { SecureRandom.uuid }

    factory :work_order_with_qc_fail do
      aliquot { build(:aliquot_fail) }
      after(:create, &:qc!)
    end

    factory :work_order_for_library_preparation do
      aliquot { build(:aliquot_proceed) }
      after(:create, &:qc!)
    end

    factory :work_order_for_sequencing do
      aliquot { create(:aliquot_proceed) }
      library
      after(:create, &:library_preparation!)
    end
  end
end
