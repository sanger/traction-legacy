# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Library, type: :model do
  it 'must have a kit number' do
    expect(build(:library, kit_number: nil)).to_not be_valid
  end

  it 'must have a volume' do
    expect(build(:library, volume: nil)).to_not be_valid
  end

  it 'must have a work_order' do
    expect(build(:library, work_order: nil)).to_not be_valid
  end

  it 'must have a tube' do
    library = create(:library)
    tube = library.tube
    expect(library.tube).to be_present
    expect(library.tube.barcode).to be_present

    found_library = Library.find(library.id)
    expect(found_library.tube).to eq(tube)
  end
end
