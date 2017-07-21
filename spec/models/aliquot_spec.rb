require 'rails_helper'

RSpec.describe Aliquot, type: :model do

  it 'can have a concentration' do
    expect(build(:aliquot, concentration: 0.003).concentration).to eq(0.003)
  end

  it 'can have a fragment size' do
    expect(build(:aliquot, fragment_size: 300).fragment_size).to eq(300)
  end

  it 'can have a qc state' do
    aliquot = build(:aliquot)
    expect(aliquot.qc_state).to be_nil

    aliquot.fail!
    expect(aliquot.qc_state).to eq('fail')

    aliquot.proceed_at_risk!
    expect(aliquot.qc_state).to eq('proceed_at_risk')

    aliquot.proceed!
    expect(aliquot.qc_state).to eq('proceed')
  end
end
