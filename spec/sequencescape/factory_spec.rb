# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Factory, type: :model do
  it 'if valid, should create correct traction objects and update sequencescape state' do
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.test_work_orders
    Sequencescape::Factory.create!(sequencescape_work_orders)
    count = sequencescape_work_orders.count
    expect(WorkOrder.count).to eq count
    expect(Tube.count).to eq count
    expect(Sample.count).to eq count
    expect(Aliquot.count).to eq count
    expect(sequencescape_work_orders.map(&:state).uniq).to eq ['started']
  end

  after(:each) do
    Sequencescape::Api::WorkOrder.destroy_test_work_orders
  end
end
