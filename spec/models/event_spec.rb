require 'rails_helper'

RSpec.describe Event, type: :model do

  it 'is not valid without a state from' do
    expect(build(:event, state_from: nil)).to_not be_valid
  end

  it 'is not valid without a state_to' do
    expect(build(:event, state_to: nil)).to_not be_valid
  end

  it 'is not valid without a work order' do
    expect(build(:event, work_order: nil)).to_not be_valid
  end

end
