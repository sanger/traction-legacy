# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrder, type: :model do
  it 'can have a state' do
    work_order = build(:work_order)
    expect(work_order).to be_started

    work_order.qc!
    expect(work_order).to be_qc

    work_order.library_preparation!
    expect(work_order).to be_library_preparation

    work_order.sequencing!
    expect(work_order).to be_sequencing

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

  it 'creates an event when saved' do
    work_order = create(:work_order)
    expect(work_order.events.count).to eq(1)
    event = work_order.events.first
    expect(event.state_from).to eq('none')
    expect(event.state_to).to eq(work_order.state)

    state = work_order.state
    work_order.qc!
    expect(work_order.events.count).to eq(2)
    event = work_order.events.last
    expect(event.state_from).to eq(state)
    expect(event.state_to).to eq(work_order.state)
  end

  it 'must have a number of flowcells' do
    expect(build(:work_order, number_of_flowcells: nil)).to_not be_valid
  end

  it 'number of flowcells cannot be updated' do
    work_order = create(:work_order)
    number_of_flowcells = work_order.number_of_flowcells
    work_order.update_attributes(number_of_flowcells: 999)
    expect(work_order.reload.number_of_flowcells).to eq(number_of_flowcells)
  end

  it 'must have a library preparation type' do
    expect(build(:work_order, library_preparation_type: nil)).to_not be_valid
  end

  it 'library preparation type cannot be updated' do
    work_order = create(:work_order)
    library_preparation_type = work_order.library_preparation_type
    work_order.update_attributes(library_preparation_type: 'any')
    expect(work_order.reload.library_preparation_type).to eq(library_preparation_type)
  end

  it 'must have a file type' do
    expect(build(:work_order, data_type: nil)).to_not be_valid
  end

  it 'file type cannot be updated' do
    work_order = create(:work_order)
    data_type = work_order.data_type
    work_order.update_attributes(data_type: 'excel')
    expect(work_order.reload.data_type).to eq(data_type)
  end

  it '#by_state returns all work orders by requested state' do
    create_list(:work_order, 5)
    create_list(:work_order_for_sequencing, 5)
    expect(WorkOrder.by_state(:library_preparation).count).to eq(5)
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

    work_order.assign_state(:qc)
    expect(WorkOrder.find(work_order.id)).to_not be_qc
    work_order.save
    expect(work_order).to be_qc

    work_order.assign_state(:completed)
    expect(WorkOrder.find(work_order.id)).to_not be_completed
    work_order.save
    expect(work_order).to be_completed
  end

  it '#editable? will check whether work order can be edited in its own right' do
    work_order = create(:work_order)
    expect(work_order).to be_editable

    work_order.qc!
    expect(work_order).to be_editable

    work_order.library_preparation!
    expect(work_order).to_not be_editable
  end

  it '#next_state will return next state of work order' do
    work_order = create(:work_order)
    expect(work_order.next_state).to eq('qc')

    work_order.qc!
    expect(work_order.next_state).to eq('library_preparation')
  end

  it 'has a unique name' do
    work_order = create(:work_order)
    expect(work_order.unique_name).to eq "#{work_order.id.to_s}:#{work_order.name}"
  end
end
