# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::OseqFlowcell, type: :model do
  subject(:instance) { described_class.new(flowcell) }
  let(:updated_at) { Time.now + 1.year }
  let(:sample) { create :sample }
  let(:study) { create :study }

  let(:flowcell) do
    create :flowcell, updated_at: updated_at
  end

  describe '#key' do
    subject { instance.key }
    it { is_expected.to eq 'oseq_flowcell' }
  end

  describe '#payload' do
    subject { instance.payload }

    let(:expected_payload) do
      {
        id_flowcell_lims: flowcell.id,
        updated_at: instance.timestamp,
        sample_uuid: flowcell.sample_uuid,
        study_uuid: flowcell.study_uuid,
        experiment_name: flowcell.experiment_name,
        instrument_name: flowcell.instrument_name,
        instrument_slot: flowcell.position,
        pipeline_id_lims: flowcell.library_preparation_type,
        requested_data_type: flowcell.data_type
      }
    end

    it { is_expected.to eq expected_payload }
  end
end
