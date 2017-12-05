# frozen_string_literal: true

FactoryGirl.define do
  factory :work_order do
    aliquot

    sequence(:sequencescape_id)
    study_uuid { SecureRandom.uuid }
    sample_uuid { SecureRandom.uuid }

    factory :gridion_work_order do
      aliquot { create(:gridion_aliquot_started) }

      transient do
        number_of_flowcells 3
        library_preparation_type 'rapid'
        data_type 'data_type'
      end

      after(:create) do |work_order, evaluator|
        pipeline = work_order.aliquot.pipeline

        number_of_flowcells = pipeline.requirements.find_by(name: 'number_of_flowcells')
        library_preparation_type = pipeline.requirements.find_by(name: 'library_preparation_type')
        data_type = pipeline.requirements.find_by(name: 'data_type')

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

      factory :gridion_work_order_ready_for_library_preparation do
        aliquot { create(:gridion_aliquot_after_qc) }
      end
      factory :gridion_work_order_ready_for_sequencing do
        aliquot { create(:gridion_aliquot_after_library_preparation) }
      end
    end
  end
end
