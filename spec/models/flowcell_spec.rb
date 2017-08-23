# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Flowcell, type: :model do
  subject(:flowcell) { build :flowcell }

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

  describe '#sample_uuid' do
    subject { flowcell.sample_uuid }
    it { is_expected.to be_a String }
    it { is_expected.to match(/\A[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}\z/) }
  end

  describe '#study_uuid' do
    subject { flowcell.study_uuid }
    it { is_expected.to be_a String }
    it { is_expected.to match(/\A[a-f0-9]{8}-([a-f0-9]{4}-){3}[a-f0-9]{12}\z/) }
  end

  describe '#experiment_name' do
    subject { flowcell.experiment_name }
    it { is_expected.to be_an Integer }
  end

  describe '#instrument_name' do
    subject { flowcell.instrument_name }
    it { is_expected.to be_a String }
  end

  describe '#library_preparation_type' do
    subject { flowcell.library_preparation_type }
    it { is_expected.to be_a String }
  end

  describe '#data_type' do
    subject { flowcell.data_type }
    it { is_expected.to be_a String }
  end

  it 'must ensure that the work order does not exceed the maximum number of flowcells' do
    work_order = create(:work_order, number_of_flowcells: 3, flowcells: create_list(:flowcell, 3))
    expect(build(:flowcell, work_order: work_order)).to_not be_valid
  end
end
