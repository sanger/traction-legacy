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

  # TODO: We are having to fill in using ids. This is bad and brittle but seems to be the
  # only way as flowcells are added via a table where each field does not have a label.
  scenario 'successful' do
    visit new_pipeline_sequencing_run_path(pipeline)
    fill_in 'Instrument name', with: sequencing_run.instrument_name

    within('#flowcell_1') do
      fill_in :gridion_sequencing_run_flowcells_attributes_0_flowcell_id, with: flowcells.first.flowcell_id
      select work_orders.first.name,
             from: :gridion_sequencing_run_flowcells_attributes_0_work_order_id
    end

    within('#flowcell_2') do
      fill_in :gridion_sequencing_run_flowcells_attributes_1_flowcell_id, with: flowcells[1].flowcell_id
      select work_orders.first.name,
             from: :gridion_sequencing_run_flowcells_attributes_1_work_order_id
    end

    within('#flowcell_3') do
      fill_in :gridion_sequencing_run_flowcells_attributes_2_flowcell_id, with: flowcells[2].flowcell_id
      select work_orders.first.name,
             from: :gridion_sequencing_run_flowcells_attributes_2_work_order_id
    end

    within('#flowcell_4') do
      fill_in :gridion_sequencing_run_flowcells_attributes_3_flowcell_id, with: flowcells[3].flowcell_id
      select work_orders.last.name,
             from: :gridion_sequencing_run_flowcells_attributes_3_work_order_id
    end

    within('#flowcell_5') do
      fill_in :gridion_sequencing_run_flowcells_attributes_4_flowcell_id, with: flowcells[4].flowcell_id
      select work_orders.last.name,
             from: :gridion_sequencing_run_flowcells_attributes_4_work_order_id
    end

    click_button 'Create Sequencing run'
    expect(page).to have_content('Sequencing run successfully created')
    sequencing_run = Gridion::SequencingRun.last
    expect(page).to have_content("experiment name: #{sequencing_run.experiment_name}")
    sequencing_run.flowcells.each do |flowcell|
      expect(page).to have_content(flowcell.flowcell_id)
    end
  end

  scenario 'failure' do
    visit new_pipeline_sequencing_run_path(pipeline)
    fill_in 'Instrument name', with: sequencing_run.instrument_name

    within('#flowcell_1') do
      select work_orders.first.name,
             from: :gridion_sequencing_run_flowcells_attributes_0_work_order_id
    end
    click_button 'Create Sequencing run'
    expect(page.text).to match('error prohibited this record from being saved')
  end

  scenario 'successful update' do
    sequencing_run = create(:sequencing_run)
    visit pipeline_sequencing_runs_path(pipeline)
    within("#gridion_sequencing_run_#{sequencing_run.id}") do
      click_link 'Edit'
    end
    select Gridion::SequencingRun.states.keys.first, from: 'State'
    fill_in 'Experiment name', with: 'new_name'
    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')
    expect(sequencing_run.reload.state).to be_present
    expect(sequencing_run.experiment_name).to eq 'new_name'
  end

  scenario 'editing includes existing flowcell work orders' do
    flowcell = create(:flowcell_in_sequencing_run, position: 1)
    sequencing_run = create(:sequencing_run, flowcells: [flowcell])
    visit edit_pipeline_sequencing_run_path(pipeline, sequencing_run)

    within('#flowcell_1') do
      expect(page).to have_content(flowcell.work_order.name)
    end
  end

  scenario 'can be deleted' do
    flowcell = create(:flowcell_in_sequencing_run, position: 1)
    sequencing_run = create(:sequencing_run, flowcells: [flowcell])
    visit edit_pipeline_sequencing_run_path(pipeline, sequencing_run)

    within('#flowcell_1') do
      select work_orders.first.name,
             from: :gridion_sequencing_run_flowcells_attributes_0_work_order_id
    end
    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')

    click_on 'Sequencing Runs'
    within("#gridion_sequencing_run_#{sequencing_run.id}") do
      click_on 'Delete'
    end
    expect(page).to have_content('Sequencing run successfully deleted')
    expect(Gridion::SequencingRun.find_by(id: sequencing_run.id)).to be nil
    expect(Flowcell.find_by(id: flowcell.id)).to be nil
    expect(work_orders.first.reload.aliquot_state).to eq 'library_preparation'
  end
end
