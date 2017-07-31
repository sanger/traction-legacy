# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrderForm, type: :model do
  let!(:work_order) { create(:work_order) }

  it 'has the correct template based on the state of the work order' do
    expect(WorkOrderForm.new(work_order).template).to eq('aliquot')
    work_order.qc!
    expect(WorkOrderForm.new(work_order).template).to eq('library')
    work_order.library_preparation!
    expect(WorkOrderForm.new(work_order).template).to be_nil
  end

  it 'validates presence of aliquot attributes if work order is started' do
    attributes = attributes_for(:aliquot_proceed)
    form = WorkOrderForm.new(work_order)

    expect(form.save(ActionController::Parameters.new(
                       aliquot_attributes: attributes.except(:concentration)
    ))).to be_falsey
    expect(form.errors).to_not be_empty

    expect(form.save(ActionController::Parameters.new(
                       aliquot_attributes: attributes.except(:fragment_size)
    ))).to be_falsey
    expect(form.errors).to_not be_empty

    expect(form.save(ActionController::Parameters.new(
                       aliquot_attributes: attributes.except(:qc_state)
    ))).to be_falsey
    expect(form.errors).to_not be_empty
  end

  it 'updates qliquot and changes state if work order is started and attributes present' do
    attributes = attributes_for(:aliquot_proceed).merge(id: work_order.aliquot.id)
    form = WorkOrderForm.new(work_order)
    expect(form.save(ActionController::Parameters.new(
                       aliquot_attributes: attributes
    ))).to be_truthy
    aliquot = work_order.aliquot
    expect(aliquot.concentration).to eq(attributes[:concentration])
    expect(aliquot.fragment_size).to eq(attributes[:fragment_size])
    expect(aliquot.qc_state).to eq(attributes[:qc_state])
    expect(work_order).to be_qc
  end

  it 'validates presence of library attributes if work order has been qced' do
    attributes = attributes_for(:library)
    work_order.qc!
    form = WorkOrderForm.new(work_order)

    expect(form.save(ActionController::Parameters.new(
                       library_attributes: attributes.except(:kit_number)
    ))).to be_falsey
    expect(form.errors).to_not be_empty
  end

  it 'updates library and changes state if work order is qc and attributes present' do
    attributes = attributes_for(:library)
    work_order.qc!
    form = WorkOrderForm.new(work_order)
    expect(form.save(ActionController::Parameters.new(
                       library_attributes: attributes
    ))).to be_truthy
    library = work_order.library
    expect(library.kit_number).to eq(attributes[:kit_number])
    expect(library.volume).to eq(attributes[:volume])
    expect(work_order).to be_library_preparation
  end

  it 'fails library preparation is sample failed qc' do
    attributes = attributes_for(:library)
    work_order = create(:work_order_with_qc_fail)
    work_order.qc!
    form = WorkOrderForm.new(work_order)
    expect(form.save(ActionController::Parameters.new(
                       library_attributes: attributes
    ))).to be_falsey
    expect(form.errors).to_not be_empty
  end
end
