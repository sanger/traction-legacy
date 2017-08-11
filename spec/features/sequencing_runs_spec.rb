# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'SequencingRuns', type: :feature do
  let!(:work_orders)    { create_list(:work_order_for_sequencing, 2, number_of_flowcells: 3) }
  let(:flowcells)       { build_list(:flowcell, 5) }
  let(:sequencing_run)  { build(:sequencing_run) }

  # TODO: We are having to fill in using ids. This is bad and brittle but seems to be the
  # only way as flowcells are added via a table where each field does not have a label.
  scenario 'successful' do
    visit new_sequencing_run_path
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

    within('#flowcell_3') do
      fill_in :sequencing_run_flowcells_attributes_2_flowcell_id, with: flowcells[2].flowcell_id
      select work_orders.first.name,
             from: :sequencing_run_flowcells_attributes_2_work_order_id
    end

    within('#flowcell_4') do
      fill_in :sequencing_run_flowcells_attributes_3_flowcell_id, with: flowcells[3].flowcell_id
      select work_orders.last.name,
             from: :sequencing_run_flowcells_attributes_3_work_order_id
    end

    within('#flowcell_5') do
      fill_in :sequencing_run_flowcells_attributes_4_flowcell_id, with: flowcells[4].flowcell_id
      select work_orders.last.name,
             from: :sequencing_run_flowcells_attributes_4_work_order_id
    end

    click_button 'Create Sequencing run'
    expect(page).to have_content('Sequencing run successfully created')
    sequencing_run = SequencingRun.last
    expect(page).to have_content("experiment name: #{sequencing_run.experiment_name}")
    sequencing_run.flowcells.each do |flowcell|
      expect(page).to have_content(flowcell.flowcell_id)
    end
  end

  scenario 'failure' do
    visit new_sequencing_run_path
    fill_in 'Instrument name', with: sequencing_run.instrument_name

    within('#flowcell_1') do
      select work_orders.first.name,
             from: :sequencing_run_flowcells_attributes_0_work_order_id
    end

    click_button 'Create Sequencing run'
    expect(page.text).to match('error prohibited this record from being saved')
  end

  scenario 'successful update' do
    sequencing_run = create(:sequencing_run)
    visit sequencing_runs_path
    within("#sequencing_run_#{sequencing_run.id}") do
      click_link 'Edit'
    end
    select SequencingRun.states.keys.first, from: 'State'
    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')
    expect(sequencing_run.reload.state).to be_present
  end
end
