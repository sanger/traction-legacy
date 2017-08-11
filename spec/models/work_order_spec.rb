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

  it 'must have a uuid' do
    expect(build(:work_order, sequencescape_id: nil)).to_not be_valid
  end

  it 'uuid cannot be updated' do
    work_order = create(:work_order)
    sequencescape_id = work_order.sequencescape_id
    work_order.update_attributes(sequencescape_id: 999)
    expect(work_order.reload.sequencescape_id).to eq(sequencescape_id)
  end

  it '#next_state! will move work order to next state' do
    work_order = create(:work_order)

    work_order.next_state!
    expect(work_order.reload).to be_qc

    work_order.next_state!
    expect(work_order.reload).to be_library_preparation

    work_order.next_state!
    expect(work_order.reload).to be_sequencing

    work_order.next_state!
    expect(work_order.reload).to be_completed

    work_order.next_state!
    expect(work_order.reload).to be_completed
  end

  it 'creates an event when saved' do
    work_order = create(:work_order)
    expect(work_order.events.count).to eq(1)
    event = work_order.events.first
    expect(event.state_from).to eq('none')
    expect(event.state_to).to eq(work_order.state)

    state = work_order.state
    work_order.next_state!
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
    expect(build(:work_order, file_type: nil)).to_not be_valid
  end

  it 'file type cannot be updated' do
    work_order = create(:work_order)
    file_type = work_order.file_type
    work_order.update_attributes(file_type: 'excel')
    expect(work_order.reload.file_type).to eq(file_type)
  end

  it '#by_state returns all work orders by requested state' do
    create_list(:work_order, 5)
    create_list(:work_order_for_sequencing, 5)
    expect(WorkOrder.by_state(:library_preparation).count).to eq(5)
  end
end
