# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sample, type: :model do
  it 'is not valid without a uuid' do
    expect(build(:sample, uuid: nil)).to_not be_valid
  end

  it 'is read only' do
    sample = create(:sample)
    expect { sample.save }.to raise_error(ActiveRecord::ReadOnlyRecord)
  end

  it 'has an aliquot' do
    sample = create(:sample)
    expect(sample.aliquot).to_not be_nil
  end
end
