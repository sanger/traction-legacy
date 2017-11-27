# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrder, type: :model do
  it 'can have a state' do
    work_order = build(:work_order)
    expect(work_order).to be_started

    work_order.completed!
    expect(work_order).to be_completed
  end

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

  it '#by_state returns all work orders by requested state' do
    create_list(:work_order, 5)
    expect(WorkOrder.by_state(:started).count).to eq(5)
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

  it '#assign_state will change state' do
    work_order = create(:work_order)

    work_order.assign_state(:completed)
    expect(WorkOrder.find(work_order.id)).to_not be_completed
    work_order.save
    expect(work_order).to be_completed
  end

  it '#editable? will check whether work order can be edited in its own right' do
    work_order = create(:work_order)
    expect(work_order).to be_editable

    work_order.completed!
    expect(work_order).to_not be_editable
  end

  it 'has a unique name' do
    work_order = create(:work_order)
    expect(work_order.unique_name).to eq "#{work_order.id}:#{work_order.name}"
  end

  context 'Grigion' do
    let!(:work_order) do
      create(:gridion_work_order, number_of_flowcells: 2,
                                  library_preparation_type: 'rapid',
                                  data_type: 'data_type')
    end

    it 'must have a number of flowcells' do
      expect(work_order.details.number_of_flowcells).to eq '2'
      expect(work_order.number_of_flowcells).to eq '2'
    end

    it 'must have a library preparation type' do
      expect(work_order.details.library_preparation_type).to eq 'rapid'
      expect(work_order.library_preparation_type).to eq 'rapid'
    end

    it 'must have a file type' do
      expect(work_order.details.data_type).to eq 'data_type'
      expect(work_order.data_type).to eq 'data_type'
    end
  end
end
