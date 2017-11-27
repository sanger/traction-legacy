# frozen_string_literal: true

module PipelineCreators
  def create_gridion_pipeline
    pipeline = create :pipeline, name: 'traction_grid_ion'
    create :requirement, name: 'number_of_flowcells', pipeline: pipeline
    create :requirement, name: 'library_preparation_type', pipeline: pipeline
    create :requirement, name: 'data_type', pipeline: pipeline
  end
end
