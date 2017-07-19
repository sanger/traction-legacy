# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sample, type: :model do
  it 'is not valid without a name' do
    expect(build(:sample, name: nil)).to_not be_valid
  end

  it 'is not valid unless the name is unique' do
    sample = create(:sample)
    expect(build(:sample, name: sample.name)).to_not be_valid
  end

  it 'can have a concentration' do
    expect(build(:sample, concentration: 0.003).concentration).to eq(0.003)
  end

  it 'can have a fragment size' do
    expect(build(:sample, fragment_size: 300).fragment_size).to eq(300)
  end

  it 'can have a qc state' do
    sample = build(:sample)
    expect(sample.qc_state).to be_nil

    sample.fail!
    expect(sample.qc_state).to eq('fail')

    sample.proceed_at_risk!
    expect(sample.qc_state).to eq('proceed_at_risk')

    sample.proceed!
    expect(sample.qc_state).to eq('proceed')
  end
end
