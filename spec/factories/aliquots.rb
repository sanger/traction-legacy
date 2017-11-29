# frozen_string_literal: true

FactoryGirl.define do
  factory :aliquot do
    sequence(:name) { |n| "DN4914#{n}A:A#{n}" }

    factory :aliquot_started do
      transient do
        pipeline { create(:standard_pipeline) }
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

      factory :aliquot_after_library_preparation do
        after(:create) do |aliquot, evaluator|
          aliquot.lab_events.create!(receptacle: evaluator.receptacle,
                                     date: DateTime.now,
                                     state: 'process_started',
                                     process_step: evaluator.pipeline.find_process_step(:library_preparation))
        end
      end
    end
  end
end
