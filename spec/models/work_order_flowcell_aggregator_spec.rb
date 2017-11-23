# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WorkOrderFlowcellAggregator, type: :model do
  let!(:work_orders_with_no_flowcells) do
    create_list(:work_order_for_sequencing, 2,
                number_of_flowcells: 3)
  end

  let!(:work_order_with_some_flowcells_1) do
    create(:work_order_for_sequencing,
           number_of_flowcells: 3, flowcells: build_list(:flowcell, 2))
  end

  let!(:work_order_with_some_flowcells_2) do
    create(:work_order_for_sequencing,
           number_of_flowcells: 3, flowcells: build_list(:flowcell, 2))
  end

  xit 'is valid if number of flowcells for each work order is within limit' do
    flowcells_a = build_list(:flowcell, 2, work_order: work_orders_with_no_flowcells.first)
    flowcells_b = build_list(:flowcell, 2, work_order: work_orders_with_no_flowcells.last)
    sequencing_run = build(:sequencing_run, flowcells: [flowcells_a, flowcells_b].flatten)
    expect(WorkOrderFlowcellAggregator.new(sequencing_run)).to be_valid
  end

  xit 'is invalid if number of flowcells for any work order exceeds number requested' do
    sequencing_run = build(:sequencing_run, flowcells: [
      build(:flowcell, work_order: work_order_with_some_flowcells_1),
      build_list(:flowcell, 2, work_order: work_order_with_some_flowcells_2)
    ].flatten)
    aggregator = WorkOrderFlowcellAggregator.new(sequencing_run)
    expect(aggregator).to_not be_valid
    expect(aggregator.errors.count).to eq(1)
    expect(aggregator.errors.full_messages).to include(
      "Work order #{work_order_with_some_flowcells_2.name}"\
      ' has more flowcells (4) than was originally requested (3)'
    )
  end

  xit 'with existing sequencing run must not count flowcells twice' do
    flowcells_a = build_list(:flowcell, 2, work_order: work_orders_with_no_flowcells.first)
    flowcells_b = build_list(:flowcell, 2, work_order: work_orders_with_no_flowcells.last)
    sequencing_run = create(:sequencing_run, flowcells: [flowcells_a, flowcells_b].flatten)
    expect(WorkOrderFlowcellAggregator.new(sequencing_run)).to be_valid
    sequencing_run.assign_attributes(flowcells: [
      build(:flowcell, work_order: work_orders_with_no_flowcells.first)
    ])
    expect(WorkOrderFlowcellAggregator.new(sequencing_run)).to be_valid

    sequencing_run = create(:sequencing_run)
    sequencing_run.assign_attributes(flowcells: [build(:flowcell,
                                                       work_order:
                                                       work_order_with_some_flowcells_1),
                                                 build_list(:flowcell, 2, work_order:
                                                 work_order_with_some_flowcells_2)].flatten)
    aggregator = WorkOrderFlowcellAggregator.new(sequencing_run)
    expect(aggregator).to_not be_valid
  end
end
