# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tube, type: :model do
  it 'can have a sample' do
    sample = build(:sample)
    expect(build(:tube, sample: sample).sample).to eq(sample)
  end
end
