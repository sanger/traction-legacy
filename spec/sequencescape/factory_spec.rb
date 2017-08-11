# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Factory, type: :model do
  include WebmockHelpers

  it 'if valid, should create correct traction objects and update sequencescape state' do
    stub :reception
    stub_updates
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.for_reception
    sequencescape_work_orders_ids = sequencescape_work_orders.map { |w| w.id.to_s }
    factory = Sequencescape::Factory.new(sequencescape_work_orders: sequencescape_work_orders,
                                         sequencescape_work_orders_ids: sequencescape_work_orders_ids) #rubocop:disable all
    expect(factory.valid?).to be true
    factory.create!
    count = sequencescape_work_orders.count
    expect(WorkOrder.count).to eq count
    expect(Tube.count).to eq count
    expect(Sample.count).to eq count
    expect(Aliquot.count).to eq count
    expect(a_request(:patch, //)).to have_been_made.times(count)
  end
end
