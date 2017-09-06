# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Factory, type: :model do
  include SequencescapeWebmockStubs

  it 'if valid, should create correct traction objects and update sequencescape state' do
    stub :successful_upload
    stub_updates
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.find_by_ids(['6','7'])
    Sequencescape::Factory.create!(sequencescape_work_orders)
    count = sequencescape_work_orders.count
    expect(WorkOrder.count).to eq count
    expect(Tube.count).to eq count
    expect(Aliquot.count).to eq count
    expect(a_request(:patch, //)).to have_been_made.times(count)
  end
end
