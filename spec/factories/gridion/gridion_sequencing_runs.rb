# frozen_string_literal: true

FactoryGirl.define do
  factory :sequencing_run, class: Gridion::SequencingRun do
    instrument_name 'clive'

    factory :sequencing_run_with_flowcells do
      after(:build) do |sequencing_run|
        sequencing_run.flowcells << build_list(:flowcell, 3, sequencing_run: sequencing_run)
      end
    end
  end
end
