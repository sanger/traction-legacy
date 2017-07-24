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
end
