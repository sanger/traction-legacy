# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Api::FakeWorkOrder, type: :model do
  it 'should not reach Sequencescape if FakeWorkOrderWork id used' do
    expect(Sequencescape::Api::FakeWorkOrder.for_reception).to eq []
    expect(Sequencescape::Api::FakeWorkOrder.find_by_ids(%w[1 2])).to eq []
    expect(Sequencescape::Api::FakeWorkOrder.update_state('test')).to eq true
  end
end
