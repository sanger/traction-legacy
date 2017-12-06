# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gridion::SequencingRunForm, type: :model do
  include SequencescapeWebmockStubs

  before(:all) do
    create :gridion_pipeline
  end

  context 'new' do
    subject { Gridion::SequencingRunForm.new }

    it '#flowcells_by_position will return the flowcells in the correct order' do
      flowcells = subject.flowcells_by_position
      expect(flowcells.count).to eq(Gridion::SequencingRunForm::MAX_FLOWCELLS)
      expect(flowcells.all?(&:new_record?)).to be_truthy
    end

    it '#created? is true' do
      expect(subject).to be_created
    end

    context 'valid' do
      let(:attributes) do
        attributes_for(:sequencing_run).merge(flowcells_attributes: build_nested_attributes_for(
          build_attributes_list_for(:flowcell, 3, 'sequencing_run_id') +
          build_attributes_list_for(:flowcell, 2, 'sequencing_run_id',
                                    'work_order_id')
        ))
      end

      it 'creates a sequencing run' do
        stub_updates
        subject.submit(attributes)
        sequencing_run = subject.sequencing_run
        expect(sequencing_run).to be_valid
        expect(sequencing_run.instrument_name).to eq(attributes[:instrument_name])
        expect(sequencing_run.experiment_name).to be_present
        expect(sequencing_run.flowcells.count).to eq(3)
      end

      it 'updates the aliquot_state of all of the work orders' do
        stub_updates
        subject.submit(attributes)
        sequencing_run = subject.sequencing_run
        expect(sequencing_run.work_orders.all? { |wo| wo.aliquot_state == 'sequencing' }).to be_truthy
      end

      it 'updates state of all of the work orders in sequencscape' do
        expect(Sequencescape::Api::WorkOrder).to receive(:update_state).exactly(3).times
        subject.submit(attributes)
      end

      xit 'knows what work orders should be updated' do
      end

      # TODO: find a better way to test this.
      it 'sends bunny messages' do
        stub_updates
        expect(Messages::Exchange.connection).to receive(:<<).exactly(3).times
        subject.submit(attributes)
      end
    end

    context 'invalid' do
      let(:attributes) do
        { flowcells_attributes: build_nested_attributes_for(
          build_attributes_list_for(:flowcell, 3, 'sequencing_run_id')
        ) }
      end

      it 'generates errors' do
        subject.submit(attributes)
        expect(subject).to_not be_valid
        expect(subject.errors).to_not be_empty
      end

      it 'does not update the state of all the work orders' do
        subject.submit(attributes)
        expect(subject.sequencing_run.work_orders.none?(&:sequencing?)).to be_truthy
      end

      it 'does not update the state of all of the work orders in sequencescape' do
        expect(Sequencescape::Api::WorkOrder).to_not receive(:update_state)
        subject.submit(attributes)
      end

      it 'does not send bunny messages' do
        expect(Messages::Exchange.connection).to_not receive(:<<)
        subject.submit(attributes)
      end
    end
  end

  context 'update' do
    let!(:flowcell_1)       { create(:flowcell_in_sequencing_run, position: 1) }
    let!(:flowcell_5)       { create(:flowcell_in_sequencing_run, position: 5) }
    let!(:sequencing_run)   { create(:sequencing_run, flowcells: [flowcell_1, flowcell_5]) }

    it '#flowcell_by_position will return the flowcells in the correct order' do
      sequencing_run_form = Gridion::SequencingRunForm.new(sequencing_run)
      flowcells = sequencing_run_form.flowcells_by_position
      expect(flowcells.first).to eq(flowcell_1)
      expect(flowcells[1]).to be_new_record
      expect(flowcells[2]).to be_new_record
      expect(flowcells[3]).to be_new_record
      expect(flowcells.last).to eq(flowcell_5)
    end

    it '#available work orders should include work orders already added to sequencing run' do
      sequencing_run_form = Gridion::SequencingRunForm.new(sequencing_run)
      expect(sequencing_run_form.available_work_orders).to include(flowcell_1.work_order)
      expect(sequencing_run_form.available_work_orders).to include(flowcell_5.work_order)
    end

    it '#created? is false' do
      sequencing_run_form = Gridion::SequencingRunForm.new(sequencing_run)
      expect(sequencing_run_form).to_not be_created
    end

    context 'completed' do
      let(:attributes)        { { state: Gridion::SequencingRun.states[:completed] } }
      subject                 { Gridion::SequencingRunForm.new(sequencing_run) }

      it 'updates the sequencing run' do
        stub_updates
        subject.submit(attributes)
        expect(subject).to be_valid
        expect(subject.sequencing_run).to be_completed
      end

      it 'updates the state of all of the work orders' do
        stub_updates
        subject.submit(attributes)
        expect(subject.sequencing_run.work_orders.all? do |work_order|
          work_order.aliquot.lab_events.last.state == 'completed'
        end).to be_truthy
      end

      it 'updates state of all of the work orders in sequencscape' do
        expect(Sequencescape::Api::WorkOrder).to receive(:update_state).exactly(2).times
        subject.submit(attributes)
      end

      it 'does not send bunny messages' do
        stub_updates
        expect(Messages::Exchange.connection).to_not receive(:<<)
        subject.submit(attributes)
      end
    end

    context 'invalid' do
      subject { Gridion::SequencingRunForm.new(sequencing_run) }

      it 'generates errors' do
        subject.submit(instrument_name: nil)
        expect(subject).to_not be_valid
        expect(subject.errors).to_not be_empty
      end
    end

    context 'not completed' do
      let(:attributes)        { { state: Gridion::SequencingRun.states[:restart] } }
      subject                 { Gridion::SequencingRunForm.new(sequencing_run) }

      it 'updates the sequencing run' do
        subject.submit(attributes)
        expect(subject).to be_valid
        expect(subject.sequencing_run).to be_restart
      end

      it 'does not update the state of all of the work orders' do
        subject.submit(attributes)
        expect(subject.sequencing_run.work_orders.none? do |work_order|
          work_order.aliquot.lab_events.last.state == 'completed'
        end).to be_truthy
      end

      it 'does not update state of all of the work orders in sequencscape' do
        expect(Sequencescape::Api::WorkOrder).to_not receive(:update_state)
        subject.submit(attributes)
      end
    end
  end
end
