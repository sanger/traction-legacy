# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrder, type: :model do
  it 'must have an aliquot' do
    expect(build(:work_order, aliquot: nil)).to_not be_valid
  end

  it 'must have a sequencescape_id' do
    expect(build(:work_order, sequencescape_id: nil)).to_not be_valid
  end

  it 'sequencescape_id cannot be updated' do
    work_order = create(:work_order)
    sequencescape_id = work_order.sequencescape_id
    work_order.update_attributes(sequencescape_id: 999)
    expect(work_order.reload.sequencescape_id).to eq(sequencescape_id)
  end

  it '#by_aliquot_state returns all work orders by requested state' do
    work_orders = create_list(:gridion_work_order, 5)
    expect(WorkOrder.by_pipeline_and_aliquot_state(work_orders.first.pipeline, :reception).count).to eq(5)
  end

  it 'must have a sample uuid' do
    expect(build(:work_order, sample_uuid: nil)).to_not be_valid
  end

  it 'sample uuid cannot be updated' do
    work_order = create(:work_order)
    sample_uuid = work_order.sample_uuid
    work_order.update_attributes(sample_uuid: SecureRandom.uuid)
    expect(work_order.reload.sample_uuid).to eq(sample_uuid)
  end

  it 'must have a study uuid' do
    expect(build(:work_order, study_uuid: nil)).to_not be_valid
  end

  it 'study uuid cannot be updated' do
    work_order = create(:work_order)
    study_uuid = work_order.study_uuid
    work_order.update_attributes(study_uuid: SecureRandom.uuid)
    expect(work_order.reload.study_uuid).to eq(study_uuid)
  end

  it 'has a unique name' do
    work_order = create(:work_order)
    expect(work_order.unique_name).to eq "#{work_order.id}:#{work_order.name}"
  end

  xit 'it knows if it went through particular step' do
  end

  xit 'can be sorted by aliquot next state' do
  end

  it 'can be sorted by pipeline and aliquot state' do
    gridion_work_orders = create_list(:gridion_work_order, 5)
    create_list(:gridion_work_order_ready_for_sequencing, 4)
    gridion = gridion_work_orders.first.pipeline
    other_work_orders = create_list(:work_order, 3)
    expect(WorkOrder.by_pipeline_and_aliquot_state(gridion).count).to eq 9
    expect(WorkOrder.by_pipeline_and_aliquot_state(other_work_orders.first.pipeline).count).to eq 3
    expect(WorkOrder.by_pipeline_and_aliquot_next_state(gridion, :sequencing).count).to eq 4
  end

  context 'Grigion' do
    let!(:work_order) do
      create(:gridion_work_order, number_of_flowcells: 2,
                                  library_preparation_type: 'rapid',
                                  data_type: 'data_type')
    end

    it 'must have a number of flowcells' do
      expect(work_order.details.number_of_flowcells).to eq '2'
    end

    it 'must have a library preparation type' do
      expect(work_order.details.library_preparation_type).to eq 'rapid'
    end

    it 'must have a file type' do
      expect(work_order.details.data_type).to eq 'data_type'
    end
  end
end
