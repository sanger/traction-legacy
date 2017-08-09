# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Factory, type: :model do
  it 'should not be valid, if sequencescape workorders were not provided or any work order does not have id, name or sample_uuid' do #rubocop:disable all
    factory = Sequencescape::Factory.new
    expect(factory.valid?).to be false
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.test_work_orders
    sequencescape_work_orders[0].id = nil
    sequencescape_work_orders[1].name = nil
    factory.sequencescape_work_orders = sequencescape_work_orders
    expect(factory.valid?).to be false
    expect(factory.errors.full_messages.join(', ')).to eq "Work orders #{sequencescape_work_orders[0].name}, #{sequencescape_work_orders[1].id} are not ready to be uploaded" #rubocop:disable all
  end

  it 'if valid, should create correct traction objects and update sequencescape state' do
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.test_work_orders
    factory = Sequencescape::Factory.new(sequencescape_work_orders: sequencescape_work_orders)
    expect(factory.valid?).to be true
    factory.create!
    traction_work_orders = WorkOrder.all
    expect(traction_work_orders.count).to eq sequencescape_work_orders.count
    expect(sequencescape_work_orders.map(&:state).uniq).to eq ['started']
  end

  after(:each) do
    Sequencescape::Api::WorkOrder.destroy_test_work_orders
  end
end
