# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Aliquot, type: :model do
  include SequencescapeWebmockStubs
  before(:all) do
    create :gridion_pipeline
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
    expect(aliquot.current_process_step_name).to eq nil
    aliquot.lab_events.create!(process_step: ProcessStep.find_by(name: 'reception'),
                               receptacle: (create :receptacle))
    aliquot.lab_events.create!(receptacle: (create :receptacle))
    expect(aliquot.current_process_step_name).to eq 'reception'
  end

  it 'knows its next process name' do
    aliquot = create :gridion_aliquot_started
    expect(aliquot.next_process_step_name).to eq 'qc'
    aliquot.lab_events.create!(process_step: ProcessStep.find_by(name: 'qc'),
                               receptacle: (create :receptacle))
    aliquot.lab_events.create!(receptacle: (create :receptacle))
    expect(aliquot.next_process_step_name).to eq 'library_preparation'
  end

  it 'creates/destroys lab events related to sequencing when required' do
    stub_updates
    work_order = create :gridion_work_order_ready_for_sequencing
    aliquot = work_order.aliquot
    lab_events_count = aliquot.lab_events.count
    aliquot.create_sequencing_event
    expect(aliquot.lab_events.count).to eq lab_events_count + 1
    expect(aliquot.state).to eq 'sequencing'
    aliquot.create_sequencing_event(:completed)
    expect(aliquot.lab_events.count).to eq lab_events_count + 2
    expect(aliquot.state).to eq 'sequencing'
    expect(aliquot.action).to eq 'completed'
    aliquot.destroy_sequencing_events
    expect(aliquot.lab_events.count).to eq lab_events_count
    expect(aliquot.state).to eq 'library_preparation'
  end

  it 'it knows if it has particular lab event' do
    aliquot = create :gridion_aliquot_after_library_preparation
    expect(aliquot.lab_event?(:qc)).to eq true
    expect(aliquot.lab_event?(:shearing)).to eq false
  end

  it 'it knows its last lab event with process step' do
    aliquot = create :gridion_aliquot_after_library_preparation
    lab_event = aliquot.lab_events.last
    expect(aliquot.last_lab_event_with_process_step).to eq lab_event
  end

  it 'knows its receptacle' do
    aliquot = create :gridion_aliquot_started
    receptacle = create :receptacle
    create :lab_event, receptacle: receptacle, aliquot: aliquot
    expect(aliquot.receptacle).to eq receptacle
  end
end
