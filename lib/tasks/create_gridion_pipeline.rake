# frozen_string_literal: true

# rubocop:disable all
namespace :gridion do
  desc 'Create gridion pipeline'
  task create: :environment do
    pipeline = Pipeline.create!(name: 'grid_ion')
    Requirement.create!(name: 'number_of_flowcells', pipeline: pipeline)
    Requirement.create!(name: 'library_preparation_type', pipeline: pipeline)
    Requirement.create!(name: 'data_type', pipeline: pipeline)

    ProcessStep.create!(name: 'reception',  pipeline: pipeline, position: 1)

    qc = ProcessStep.create!(name: 'qc',  pipeline: pipeline, position: 2)
    MetadataField.create!(name: 'concentration',
                          required: true,
                          process_step: qc,
                          data_type: :integer)
    MetadataField.create!(name: 'fragment_size',
                          required: true,
                          process_step: qc,
                          data_type: :integer)
    qc_state = MetadataField.create!(name: 'qc_state',
                                    required: true,
                                    process_step: qc,
                                    data_type: :options)
    Option.create!(name: 'fail', metadata_field: qc_state)
    Option.create!(name: 'proceed_at_risk', metadata_field: qc_state)
    Option.create!(name: 'proceed', metadata_field: qc_state)

    library_preparation = ProcessStep.create!(name: 'library_preparation', pipeline: pipeline, position: 3)
    MetadataField.create!(name: 'volume',
                          required: true,
                          process_step: library_preparation,
                          data_type: :integer)
    MetadataField.create!(name: 'kit_number',
                          required: true,
                          process_step: library_preparation,
                          data_type: :string)
    MetadataField.create!(name: 'ligase_batch_number',
                          required: false,
                          process_step: library_preparation,
                          data_type: :string)

    ProcessStep.create!(name: 'sequencing', pipeline: pipeline, position: 4)
  end
end
# rubocop:enable all