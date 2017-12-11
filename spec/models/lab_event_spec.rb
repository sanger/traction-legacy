# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabEvent, type: :model do
  include SequencescapeWebmockStubs

  before(:all) do
    create :gridion_pipeline
  end

  let(:pipeline) { Pipeline.first }

  it 'can be created with work_order_id and metadata_items_attributes data' do
    stub_updates
    work_order = create :gridion_work_order
    aliquot = work_order.aliquot
    qc = pipeline.find_process_step(:qc)
    metadata_items_attributes = { 'concentration' => '10', 'fragment_size' => '50', 'qc_state' => 'fail' }
    lab_event = LabEvent.create!(metadata_items_attributes: metadata_items_attributes,
                                 work_order_id: work_order.id,
                                 process_step_id: qc.id)
    expect(lab_event.aliquot).to eq aliquot
    expect(lab_event.receptacle).to eq aliquot.receptacle
    expect(lab_event.reload.metadata).to eq('concentration' => '10', 'fragment_size' => '50', 'qc_state' => 'fail')
  end

  it 'it updates sequencescape when required' do
    stub_updates
    work_order = create :gridion_work_order
    expect(Sequencescape::Api::WorkOrder).to receive(:update_state).once
    create :lab_event, aliquot: work_order.aliquot
  end
end
