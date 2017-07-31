# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workflow::Step, type: :model, workflow: true do

  let(:attributes) { { name: :step_2, state: :second_step, heading: 'The second step', previous_step: :step_1, next_step: :step_3} }

  it 'is valid with all valid attributes' do
    expect(Workflow::Step.new(attributes)).to be_valid
  end

  it 'must have a name' do
    expect(Workflow::Step.new(attributes.except(:name))).to_not be_valid
  end

  it 'must have a heading' do
    expect(Workflow::Step.new(attributes).heading).to eq(attributes[:heading])
    expect(Workflow::Step.new(attributes.except(:heading)).heading).to eq("Step 2")
  end

  it 'must have a state' do
    expect(Workflow::Step.new(attributes).state).to eq(attributes[:state])
    expect(Workflow::Step.new(attributes.except(:state)).state).to eq(:step_2)
  end

  it 'can have a previous step' do
    expect(Workflow::Step.new(attributes).previous_step).to eq(attributes[:previous_step])
  end

  it 'can have a next step' do
    expect(Workflow::Step.new(attributes).next_step).to eq(attributes[:next_step])
  end

  it 'is the first step if there is no previous step' do
    expect(Workflow::Step.new(attributes.except(:previous_step))).to be_first
  end

  it 'is the last step if there is no next step' do
    expect(Workflow::Step.new(attributes.except(:next_step))).to be_last
  end

end