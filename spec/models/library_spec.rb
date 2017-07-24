require 'rails_helper'

RSpec.describe Library, type: :model do

  it 'must have a kit number' do
    expect(build(:library, kit_number: nil)).to_not be_valid
  end

  it 'must have a volume' do
    expect(build(:library, volume: nil)).to_not be_valid
  end

  it 'must have an aliquot' do
    expect(build(:library, aliquot: nil)).to_not be_valid
  end
  
end
