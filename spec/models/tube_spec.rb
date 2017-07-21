# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tube, type: :model do

  it 'must have a barcode' do
    tube = create(:tube)
    expect(tube.barcode).to eq("TRAC-#{tube.id}")
  end

  # it 'can have a sample' do
  #   sample = build(:sample)
  #   expect(build(:tube, sample: sample).sample).to eq(sample)
  # end
end
