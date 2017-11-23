# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrderForm, type: :model do
  include SequencescapeWebmockStubs

  context 'qc' do
    let!(:work_order) { create(:work_order) }

    context 'successful' do
      let(:attributes) do
        attributes_for(:aliquot_proceed).except(:name)
                                        .merge(id: work_order.aliquot.id)
      end
      subject { WorkOrderForm::Qc.new(work_order) }

      it 'updates the aliquot' do
        stub_updates
        subject.submit(aliquot_attributes: attributes)
        expect(subject).to be_valid
        aliquot = subject.work_order.aliquot
        expect(aliquot.concentration).to eq(attributes[:concentration])
        expect(aliquot.fragment_size).to eq(attributes[:fragment_size])
        expect(aliquot.qc_state).to eq(attributes[:qc_state])
      end

      it 'updates state of work order' do
        stub_updates
        subject.submit(aliquot_attributes: attributes)
        expect(work_order).to be_qc
      end

      it 'updates state of work order in sequencscape' do
        expect(Sequencescape::Api::WorkOrder).to receive(:update_state).once
        subject.submit(aliquot_attributes: attributes)
      end
    end

    context 'unsuccessful' do
      let(:attributes) do
        attributes_for(:aliquot_proceed).except(:name, :concentration)
                                        .merge(id: work_order.aliquot.id)
      end
      subject { WorkOrderForm::Qc.new(work_order) }

      it 'produces errors' do
        subject.submit(aliquot_attributes: attributes)
        expect(subject).to_not be_valid
        expect(subject.errors).to_not be_empty
      end

      it 'does not update state of work order' do
        subject.submit(aliquot_attributes: attributes)
        expect(work_order).to be_started
      end

      it 'does not update state of work order in sequencescape' do
        expect(Sequencescape::Api::WorkOrder).to_not receive(:update_state)
        subject.submit(aliquot_attributes: attributes)
      end
    end
  end
end
