# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flowcell, type: :model do
  it 'must belong to a work order' do
    expect(build(:flowcell, work_order: nil)).to_not be_valid
  end

  it 'must belong to a sequencing run' do
    expect(build(:flowcell, sequencing_run: nil)).to_not be_valid
  end

  it 'must have an flowcell_id' do
    expect(build(:flowcell, flowcell_id: nil)).to_not be_valid
  end

  it 'must have a position' do
    expect(build(:flowcell, position: nil)).to_not be_valid
  end
end
