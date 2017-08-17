# frozen_string_literal: true

# See ../messages.rb
module Messages
  # An Oseq_flowcell represents to contents of an individual flowcell
  class OseqFlowcell < Base
    self.key = 'oseq_flowcell'

    alias flowcell resource

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    # While we could look at a DSL to help DRY this out slightly
    # and solve Rubocop's issues, at this stage this feels like
    # an overall *increase* in complexity, especially as we
    # only have a single message.
    def content
      {
        id_flowcell_lims: flowcell.id,
        updated_at: timestamp,
        sample_uuid: flowcell.sample_uuid,
        study_uuid: flowcell.study_uuid,
        experiment_name: flowcell.experiment_name,
        instrument_name: flowcell.instrument_name,
        instrument_slot: flowcell.position,
        pipeline_id_lims: flowcell.library_preparation_type,
        requested_data_type: flowcell.data_type
      }
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
  end
end
