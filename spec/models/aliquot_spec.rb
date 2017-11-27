# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Aliquot, type: :model do
  include PipelineCreators

  before(:all) do
    create_gridion_pipeline
  end

  it 'is not valid without a name' do
    expect(build(:aliquot, name: nil)).to_not be_valid
  end

  it 'can have a source_plate_barcode' do
    aliquot = build(:aliquot, name: 'DN491410A:A1')
    expect(aliquot.source_plate_barcode).to eq('DN491410A')
  end

  it 'can have a source_well_position' do
    aliquot = build(:aliquot, name: 'DN491410A:A1')
    expect(aliquot.source_well_position).to eq('A1')
  end

  it 'can have a short_source_plate_barcode' do
    aliquot = build(:aliquot, name: 'DN491410A:A1')
    expect(aliquot.short_source_plate_barcode).to eq('410A')
  end

  it 'knows its current process' do
    aliquot = create :aliquot
    expect(aliquot.current_process_step_name).to eq 'not started'
    aliquot.lab_events.create!(process_step: ProcessStep.find_by(name: 'qc'),
                               receptacle: (create :receptacle))
    aliquot.lab_events.create!(receptacle: (create :receptacle))
    expect(aliquot.current_process_step_name).to eq 'qc'
  end

  it 'knows its next process name' do
    aliquot = create :aliquot
    expect(aliquot.next_process_step_name).to eq nil
    aliquot.lab_events.create!(process_step: ProcessStep.find_by(name: 'qc'),
                               receptacle: (create :receptacle))
    aliquot.lab_events.create!(receptacle: (create :receptacle))
    expect(aliquot.next_process_step_name).to eq 'library_preparation'
  end
end
