# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SequencingRun, type: :model do
  it 'must have an instrument name' do
    expect(build(:sequencing_run, instrument_name: nil)).to_not be_valid
  end

  it '#experiment_name is the id by default, but can be changed' do
    sequencing_run = create(:sequencing_run)
    expect(sequencing_run.experiment_name).to eq(sequencing_run.id)
    sequencing_run.experiment_name = 'new_name'
    expect(sequencing_run.experiment_name).to eq('new_name')
    sequencing_run.save
    expect(sequencing_run.experiment_name).to eq('new_name')
  end

  it 'removes any flowcells which do not have a work order before validation' do
    sequencing_run = create(:sequencing_run,
                            flowcells_attributes: build_nested_attributes_for(
                              build_attributes_list_for(:flowcell, 3, 'sequencing_run_id') +
                              build_attributes_list_for(:flowcell, 2, 'sequencing_run_id',
                                                        'work_order_id')
                            ))
    expect(sequencing_run.flowcells.count).to eq(3)
  end

  it 'destroys flowcells if requested' do
    sequencing_run = create(:sequencing_run,
                            flowcells_attributes: build_nested_attributes_for(
                              build_attributes_list_for(:flowcell, 3, 'sequencing_run_id') +
                              build_attributes_list_for(:flowcell, 2, 'sequencing_run_id',
                                                        'work_order_id')
                            ))
    flowcell = sequencing_run.flowcells.first
    params = { flowcells_attributes: [{ id: flowcell.id, _destroy: '1' }] }
    sequencing_run.assign_attributes(params)
    sequencing_run.save
    expect(sequencing_run.flowcells.count).to eq(2)
    expect(sequencing_run.flowcells).not_to include(flowcell)
  end

  it 'ensures that the work order is not spread across more flowcells than have been requested' do
    work_order = create(:gridion_work_order, number_of_flowcells: 3)
    sequencing_run = build(:sequencing_run, flowcells: build_list(
      :flowcell, 5, work_order: work_order
    ))

    expect(sequencing_run.save).to be_falsey
    expect(sequencing_run.errors).to_not be_empty

    work_order = create(:gridion_work_order, number_of_flowcells: 3)
    create(:sequencing_run, flowcells: build_list(
      :flowcell, 2, work_order: work_order
    ))
    work_order.reload
    sequencing_run = build(:sequencing_run, flowcells: build_list(
      :flowcell, 3, work_order: work_order
    ))
    expect(sequencing_run.save).to be_falsey
    expect(sequencing_run.errors).to_not be_empty
  end

  xit 'ensures that the work orders are in the right state' do
    work_order = create(:gridion_work_order, number_of_flowcells: 3)
    expect(build(:sequencing_run, flowcells: build_list(
      :flowcell, 3, work_order: work_order
    ))).to_not be_valid
  end

  it 'can have state' do
    sequencing_run = create(:sequencing_run)
    expect(sequencing_run).to be_pending

    sequencing_run.completed!
    expect(sequencing_run).to be_completed

    sequencing_run.user_terminated!
    expect(sequencing_run).to be_user_terminated

    sequencing_run.instrument_crashed!
    expect(sequencing_run).to be_instrument_crashed

    sequencing_run.restart!
    expect(sequencing_run).to be_restart
  end
end
