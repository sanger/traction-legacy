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
    expect(build(:work_order, uuid: nil)).to_not be_valid
  end

  it 'uuid cannot be updated' do
    work_order = create(:work_order)
    uuid = work_order.uuid
    work_order.update_attributes(uuid: SecureRandom.uuid)
    expect(work_order.reload.uuid).to eq(uuid)
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

  it '#sample_name returns sample name' do
    work_order = build(:work_order)
    expect(work_order.sample_name).to eq(work_order.aliquot.sample.name)
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
end
