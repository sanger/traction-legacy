# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sqsc::Factory, type: :model do
  it 'should not be valid, if sqsc workorders were not provided or any work order does not have id, name or sample_uuid' do #rubocop:disable all
    factory = Sqsc::Factory.new
    expect(factory.valid?).to be false
    sqsc_work_orders = Sqsc::Api::WorkOrder.test_work_orders
    sqsc_work_orders[0].id = nil
    sqsc_work_orders[1].name = nil
    factory.sqsc_work_orders = sqsc_work_orders
    expect(factory.valid?).to be false
    expect(factory.errors.full_messages.join(', ')).to eq "Work orders #{sqsc_work_orders[0].name}, #{sqsc_work_orders[1].id} are not ready to be uploaded" #rubocop:disable all
  end

  it 'if valid, should create correct traction objects and update sqsc state' do
    sqsc_work_orders = Sqsc::Api::WorkOrder.test_work_orders
    factory = Sqsc::Factory.new(sqsc_work_orders: sqsc_work_orders)
    expect(factory.valid?).to be true
    factory.create!
    traction_work_orders = WorkOrder.all
    expect(traction_work_orders.count).to eq sqsc_work_orders.count
    expect(sqsc_work_orders.map(&:state).uniq).to eq ['started']
  end

  after(:each) do
    Sqsc::Api::WorkOrder.destroy_test_work_orders
  end
end
