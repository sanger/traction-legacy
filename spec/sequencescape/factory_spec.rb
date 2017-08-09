# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Factory, type: :model do
  it 'should not be valid, if sequencescape workorders were not provided, not all found or any work order does not have id, name or sample_uuid' do #rubocop:disable all
    factory = Sequencescape::Factory.new
    expect(factory.valid?).to be false
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.create_invalid_test_work_orders
    factory.sequencescape_work_orders = sequencescape_work_orders
    factory.sequencescape_work_orders_ids = sequencescape_work_orders.map { |w| w.id.to_s } + ['bad_id'] #rubocop:disable all
    expect(factory.valid?).to be false
    messages = { work_orders:
                  ['with ids bad_id were not found in Sequencescape, please contact PSD',
                  "#{sequencescape_work_orders[0].name}, #{sequencescape_work_orders[1].id} are not ready to be uploaded, please contact PSD"]} #rubocop:disable all
    expect(factory.errors.messages).to eq messages
  end

  it 'if valid, should create correct traction objects and update sequencescape state' do
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.test_work_orders
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
    expect(sequencescape_work_orders.map(&:state).uniq).to eq ['started']
  end

  after(:each) do
    Sequencescape::Api::WorkOrder.destroy_test_work_orders
  end
end
