# frozen_string_literal: true

FactoryGirl.define do
  factory :pipeline do
    name 'Pipeline1'

    factory :standard_pipeline do
      after(:create) do |pipeline|
        pipeline.process_steps.create!(name: 'reception', position: 1)
        pipeline.process_steps.create!(name: 'library_preparation', position: 2)
        pipeline.process_steps.create!(name: 'sequencing', position: 3)
      end
    end

    factory :gridion_pipeline do
      name 'grid_ion'
      after(:create) do |pipeline|
        create :requirement, name: 'number_of_flowcells', pipeline: pipeline
        create :requirement, name: 'library_preparation_type', pipeline: pipeline
        create :requirement, name: 'data_type', pipeline: pipeline

        create :process_step, name: 'reception',  pipeline: pipeline, position: 1

        qc = create :process_step, name: 'qc', pipeline: pipeline, position: 2
        create :metadata_field, name: 'concentration',
                                required: true,
                                process_step: qc,
                                data_type: :integer
        create :metadata_field, name: 'fragment_size',
                                required: true,
                                process_step: qc,
                                data_type: :integer
        qc_state = create :metadata_field, name: 'qc_state',
                                           required: true,
                                           process_step: qc,
                                           data_type: :options
        create :option, name: 'fail', metadata_field: qc_state
        create :option, name: 'proceed_at_risk', metadata_field: qc_state
        create :option, name: 'proceed', metadata_field: qc_state

        library_preparation = create :process_step, name: 'library_preparation',
                                                    pipeline: pipeline, position: 3
        create :metadata_field, name: 'volume',
                                required: true,
                                process_step: library_preparation,
                                data_type: :integer
        create :metadata_field, name: 'kit_number',
                                required: true,
                                process_step: library_preparation,
                                data_type: :string
        create :metadata_field, name: 'ligase_batch_number',
                                required: false,
                                process_step: library_preparation,
                                data_type: :string

        create :process_step, name: 'sequencing', pipeline: pipeline, position: 5
      end
    end
  end
end
