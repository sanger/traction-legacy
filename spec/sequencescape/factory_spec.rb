# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sequencescape::Factory, type: :model do
  include SequencescapeWebmockStubs

  context 'gridion' do
    it 'if valid, should create correct traction objects and update sequencescape state' do
      pipeline = create :pipeline, name: 'traction_grid_ion'
      create :requirement, name: 'number_of_flowcells', pipeline: pipeline
      create :requirement, name: 'library_preparation_type', pipeline: pipeline
      create :requirement, name: 'data_type', pipeline: pipeline
      stub :successful_upload
      stub_updates
      sequencescape_work_orders = Sequencescape::Api::WorkOrder.find_by_ids(%w[6 7])
      Sequencescape::Factory.create!(sequencescape_work_orders)
      count = sequencescape_work_orders.count
      expect(WorkOrder.count).to eq count
      expect(Receptacle.count).to eq count
      expect(Aliquot.count).to eq count
      expect(LabEvent.count).to eq count
      expect(a_request(:patch, //)).to have_been_made.times(count)
    end
  end
end
