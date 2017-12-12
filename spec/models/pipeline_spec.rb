# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pipeline, type: :model do
  it 'knows next process' do
    pipeline = create :pipeline, name: 'traction_grid_ion'
    process1 = create :process_step, name: 'process1', pipeline: pipeline, position: 1
    process2 = create :process_step, name: 'process2', pipeline: pipeline, position: 2
    process3 = create :process_step, name: 'process3', pipeline: pipeline, position: 3

    expect(pipeline.next_process_step(nil)).to eq process1
    expect(pipeline.next_process_step(process1)).to eq process2
    expect(pipeline.next_process_step(process3)).to eq nil
  end
end
