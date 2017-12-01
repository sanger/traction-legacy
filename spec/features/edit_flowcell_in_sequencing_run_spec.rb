# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'SequencingRuns', type: :feature do
  include SequencescapeWebmockStubs

  before(:all) do
    create :gridion_pipeline
  end

  let!(:work_orders)    { create_list(:gridion_work_order_ready_for_sequencing, 2, number_of_flowcells: 3) }
  let(:flowcells)       { build_list(:flowcell, 5) }
  let(:sequencing_run)  { build(:sequencing_run) }
  let!(:pipeline)       { Pipeline.first }

  before(:each) do
    stub_updates
  end

  scenario 'create and edit sequencing run' do
    # create sequencing run with the same sample on two flowcells (sample-1)
    visit new_pipeline_sequencing_run_path(pipeline)
    fill_in 'Instrument name', with: sequencing_run.instrument_name

    within('#flowcell_1') do
      fill_in :sequencing_run_flowcells_attributes_0_flowcell_id, with: flowcells.first.flowcell_id
      select work_orders.first.name,
             from: :sequencing_run_flowcells_attributes_0_work_order_id
    end

    within('#flowcell_2') do
      fill_in :sequencing_run_flowcells_attributes_1_flowcell_id, with: flowcells[1].flowcell_id
      select work_orders.first.name,
             from: :sequencing_run_flowcells_attributes_1_work_order_id
    end

    click_button 'Create Sequencing run'
    expect(page).to have_content('Sequencing run successfully created')

    # edit sequencing run
    # changed sample on the second flowcell
    # now sample-1 is on the first flowcell and sample-2 is on the second flowcell
    sequencing_run = SequencingRun.last
    visit edit_pipeline_sequencing_run_path(pipeline, sequencing_run)

    within('#flowcell_2') do
      fill_in :sequencing_run_flowcells_attributes_1_flowcell_id, with: flowcells[1].flowcell_id
      select work_orders.last.name,
             from: :sequencing_run_flowcells_attributes_1_work_order_id
    end

    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')

    expect(sequencing_run.work_orders.count).to eq 2
    sequencing_run.work_orders.each do |work_order|
      expect(work_order.aliquot_state).to eq 'sequencing'
    end

    # removed one flowcell from the sequencing run
    # now flowcell 1 is empty, flowcell 2 has sample-2
    visit edit_pipeline_sequencing_run_path(pipeline, sequencing_run)

    within('#flowcell_1') do
      check :sequencing_run_flowcells_attributes_0__destroy
    end

    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')
    expect(sequencing_run.work_orders.count).to eq 1
    expect(work_orders.first.reload.aliquot_state).to eq 'library_preparation'
    expect(work_orders.last.reload.aliquot_state).to eq 'sequencing'

    # now in flowcell 2, I change sample-2 to sample-1
    # as a result work_order with sample 2 should go to 'library preparation state'
    # work_order with sample-1 should go to 'sequencing' state
    visit edit_pipeline_sequencing_run_path(pipeline, sequencing_run)
    within('#flowcell_2') do
      select work_orders.first.name,
             from: :sequencing_run_flowcells_attributes_1_work_order_id
    end
    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')
    expect(work_orders.first.reload.aliquot_state).to eq 'sequencing'
    expect(work_orders.last.reload.aliquot_state).to eq 'library_preparation'
  end
end
