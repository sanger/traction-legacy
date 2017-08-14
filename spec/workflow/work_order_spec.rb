# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workflow::WorkOrder, type: :model, workflow: true do

  subject { Workflow::WorkOrder.new }

  it 'has initial state' do
    expect(subject).to be_started
    expect(subject.state).to eq(:started)
  end

  it 'can transition from started to qc' do
    subject.qc!
    expect(subject).to be_qc
    expect(subject.state).to eq(:qc)
  end

  it 'can transition from qc to library preparation' do
    subject.qc!
    subject.library_preparation!
    expect(subject).to be_library_preparation
    expect(subject.state).to eq(:library_preparation)
  end

  it 'can transition from library preparaton to sequencing' do
    subject.qc!
    subject.library_preparation!
    subject.sequencing!
    expect(subject).to be_sequencing
    expect(subject.state).to eq(:sequencing)
  end

  it 'can transition from sequencing to completed' do
    subject.qc!
    subject.library_preparation!
    subject.sequencing!
    subject.completed!
    expect(subject).to be_completed
    expect(subject.state).to eq(:completed)
  end
end