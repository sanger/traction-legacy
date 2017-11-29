namespace :gridion do
  desc 'Create gridion pipeline'
  task create: :environment do
    pipeline = Pipeline.create!(name: 'traction_grid_ion')
    Requirement.create!(name: 'number_of_flowcells', pipeline: pipeline)
    Requirement.create!(name: 'library_preparation_type', pipeline: pipeline)
    Requirement.create!(name: 'data_type', pipeline: pipeline)

    ProcessStep.create!(name: 'started',  pipeline: pipeline, position: 1)

    qc = ProcessStep.create!(name: 'qc',  pipeline: pipeline, position: 2)
    MetadataField.create!(name: 'concentration',
                            required: true,
                            process_step: qc,
                            data_type: :integer)
    MetadataField.create!(name: 'fragment_size',
                            required: true,
                            process_step: qc,
                            data_type: :integer)
    MetadataField.create!(name: 'qc_state',
                            required: true,
                            process_step: qc,
                            data_type: :options)

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