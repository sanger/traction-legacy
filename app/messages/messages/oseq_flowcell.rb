# frozen_string_literal: true

# See ../messages.rb
module Messages
  # An Oseq_flowcell represents to contents of an individual flowcell
  class OseqFlowcell
    class_attribute :key
    self.key = 'oseq_flowcell'

    attr_reader :flowcell, :timestamp

    def initialize(flowcell)
      @flowcell = flowcell
      @timestamp = Time.now
    end

    def payload
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
  end
end
