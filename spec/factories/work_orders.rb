# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order do
    aliquot

    sequence(:sequencescape_id)
    study_uuid { SecureRandom.uuid }
    sample_uuid { SecureRandom.uuid }

    factory :gridion_work_order do
      aliquot { create(:aliquot_started) }

      transient do
        number_of_flowcells 3
        library_preparation_type 'rapid'
        data_type 'data_type'
      end

      after(:create) do |work_order, evaluator|
        pipeline = create :pipeline, name: 'traction_grid_ion'

        number_of_flowcells = create :requirement, name: 'number_of_flowcells', pipeline: pipeline
        library_preparation_type = create :requirement, name: 'library_preparation_type', pipeline: pipeline
        data_type = create :requirement, name: 'data_type', pipeline: pipeline

        create :work_order_requirement, requirement: number_of_flowcells,
                                        work_order: work_order,
                                        value: evaluator.number_of_flowcells
        create :work_order_requirement, requirement: library_preparation_type,
                                        work_order: work_order,
                                        value: evaluator.library_preparation_type
        create :work_order_requirement, requirement: data_type,
                                        work_order: work_order,
                                        value: evaluator.data_type
      end
    end
  end
end
