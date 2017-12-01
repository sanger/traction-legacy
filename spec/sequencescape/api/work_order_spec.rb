# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Api::WorkOrder, type: :model do
  include SequencescapeWebmockStubs

  it 'should request for pending work orders from Sequencescape' do
    stub_reception = stub :reception
    Sequencescape::Api::WorkOrder.for_reception
    assert_requested(stub_reception)
  end

  it 'should request for work orders with particular ids from Sequencescape for upload' do
    stub_for_upload = stub :successful_upload
    Sequencescape::Api::WorkOrder.find_by_ids(%w[6 7])
    assert_requested(stub_for_upload)
  end

  it 'should request to update work order to Sequencescape' do
    work_order = create :work_order
    stub_find_by_id = stub :find_by_id
    stub_update_attributes = stub_updates
    Sequencescape::Api::WorkOrder.update_state(work_order)
    assert_requested(stub_find_by_id)
    assert_requested(stub_update_attributes)
  end

  xit 'knows what state to use to update sequencescape' do
  end

  after do
    Rails.configuration.sequencescape_disabled = false
  end
end
