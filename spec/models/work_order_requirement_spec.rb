# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrderRequirement, type: :model do
  it 'should provide key-value hash' do
    requirement = create :requirement, name: 'key'
    work_order_requirement = create(:work_order_requirement, value: 'value', requirement: requirement)
    expect(work_order_requirement.to_h).to eq('key' => 'value')
  end

  it 'should have readonly value' do
    work_order_requirement = create(:work_order_requirement)
    value = work_order_requirement.value
    work_order_requirement.update_attributes(value: 'new_value')
    expect(work_order_requirement.reload.value).to eq(value)
  end
end
