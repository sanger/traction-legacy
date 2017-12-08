# frozen_string_literal: true

require_relative './../support/factory_girl_helpers'

FactoryGirl.define do
  factory :aliquot do
    sequence(:name) { |n| "DN4914#{n}A:A#{n}" }

    factory :aliquot_started do
      transient do
        pipeline { Pipeline.find_by(name: 'standard') || create(:standard_pipeline) }
        receptacle { create(:receptacle) }
      end

      after(:create) do |aliquot, evaluator|
        aliquot.lab_events.create!(receptacle: evaluator.receptacle,
                                   date: DateTime.now,
                                   state: 'transferred')
        aliquot.lab_events.create!(receptacle: evaluator.receptacle,
                                   date: DateTime.now,
                                   state: 'process_started',
                                   process_step: evaluator.pipeline.process_steps.first)
      end
    end

    factory :gridion_aliquot_started do
      transient do
        pipeline { Pipeline.find_by(name: 'grid_ion') || create(:gridion_pipeline) }
        receptacle { create(:receptacle) }
      end

      after(:create) do |aliquot, evaluator|
        aliquot.lab_events.create!(receptacle: evaluator.receptacle,
                                   date: DateTime.now,
                                   state: 'transferred')
        aliquot.lab_events.create!(receptacle: evaluator.receptacle,
                                   date: DateTime.now,
                                   state: 'process_started',
                                   process_step: evaluator.pipeline.process_steps.first)
      end

      factory :gridion_aliquot_after_qc do
        after(:create) do |aliquot, evaluator|
          qc = evaluator.pipeline.find_process_step(:qc)
          aliquot.lab_events.create!(receptacle: evaluator.receptacle,
                                     date: DateTime.now,
                                     state: 'process_started',
                                     process_step: qc,
                                     metadata_items_attributes: FactoryGirlHelpers.build_metadata_attributes_for(qc)) #rubocop:disable all
        end

        factory :gridion_aliquot_after_library_preparation do
          after(:create) do |aliquot, evaluator|
            library_preparation = evaluator.pipeline.find_process_step(:library_preparation)
            aliquot.lab_events.create!(receptacle: evaluator.receptacle,
                                       date: DateTime.now,
                                       state: 'process_started',
                                       process_step: library_preparation,
                                       metadata_items_attributes: FactoryGirlHelpers.build_metadata_attributes_for(library_preparation)) #rubocop:disable all
          end
        end
      end
    end
  end
end
