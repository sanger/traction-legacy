# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'SequencingRuns', type: :feature do
  include SequencescapeWebmockStubs

  let!(:work_orders)    { create_list(:work_order_for_sequencing, 2, number_of_flowcells: 3) }
  let(:flowcells)       { build_list(:flowcell, 5) }
  let(:sequencing_run)  { build(:sequencing_run) }

  before(:each) do
    stub_updates
  end

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

    click_button 'Create Sequencing run'
    expect(page).to have_content('Sequencing run successfully created')

    sequencing_run = SequencingRun.last
    visit edit_sequencing_run_path(sequencing_run)

    within('#flowcell_2') do
      fill_in :sequencing_run_flowcells_attributes_1_flowcell_id, with: flowcells[1].flowcell_id
      select work_orders.last.name,
             from: :sequencing_run_flowcells_attributes_1_work_order_id
    end

    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')

    work_orders = sequencing_run.work_orders
    expect(work_orders.count).to eq 2
    work_orders.each do |work_order|
      expect(work_order.state).to eq 'sequencing'
    end

    visit edit_sequencing_run_path(sequencing_run)

    within('#flowcell_1') do
      check :sequencing_run_flowcells_attributes_0__destroy
    end

    click_button 'Update Sequencing run'
    expect(page).to have_content('Sequencing run successfully updated')
    new_work_orders = sequencing_run.work_orders
    expect(new_work_orders.count).to eq 1
    expect(new_work_orders.first.state).to eq 'sequencing'
    expect(work_orders.first.reload.state).to eq 'library_preparation'
  end
end
