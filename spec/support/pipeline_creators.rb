# frozen_string_literal: true

module PipelineCreators
  # rubocop:disable Metrics/MethodLength
  def create_gridion_pipeline
    pipeline = create :pipeline, name: 'traction_grid_ion'
    create :requirement, name: 'number_of_flowcells', pipeline: pipeline
    create :requirement, name: 'library_preparation_type', pipeline: pipeline
    create :requirement, name: 'data_type', pipeline: pipeline

    qc = create :process_step, name: 'qc',  pipeline: pipeline
    create :metadata_field, name: 'concentration',
                            required: true,
                            process_step: qc,
                            data_type: :integer
    create :metadata_field, name: 'fragment_size',
                            required: true,
                            process_step: qc,
                            data_type: :integer
    create :metadata_field, name: 'qc_state',
                            required: true,
                            process_step: qc,
                            data_type: :options

    library_preparation = create :process_step, name: 'library_preparation', pipeline: pipeline
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
  end
end