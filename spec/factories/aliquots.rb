# frozen_string_literal: true

FactoryGirl.define do
  factory :aliquot do
    sequence(:name) { |n| "DN4914#{n}A:A#{n}" }

    factory :aliquot_started do
      after(:create) do |aliquot|
        pipeline = create :standard_pipeline
        receptacle = create :receptacle
        aliquot.lab_events.create!(receptacle: receptacle,
                                   date: DateTime.now,
                                   state: 'transferred')
        aliquot.lab_events.create!(receptacle: receptacle,
                                   date: DateTime.now,
                                   state: 'process_started',
                                   process_step: pipeline.process_steps.first)
      end
    end
  end
end
