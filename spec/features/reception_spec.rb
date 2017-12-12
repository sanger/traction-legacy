# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Reception', type: :feature do
  include SequencescapeWebmockStubs

  before(:all) do
    create :gridion_pipeline
  end

  let!(:pipeline) { Pipeline.first }

  scenario 'new sequencescape workorders should be on the reception page' do
    stub :reception
    work_orders = Sequencescape::Api::WorkOrder.for_reception(pipeline)
    visit pipeline_work_orders_path(pipeline)
    click_on 'Reception'
    expect(page).to have_current_path(pipeline_reception_path(pipeline))
    expect(page).to have_selector('table tr', count: 5)
    page.find_all('table tr').each_with_index do |row, index|
      fields = row.find_all('td')
      expect(fields[1].text).to eq work_orders[index].name
      expect(fields[2].text).to eq work_orders[index].state
    end
  end

  scenario 'upload work orders successfully' do
    stub :reception
    stub :successful_upload
    stub_updates
    Sequencescape::Api::WorkOrder.for_reception(pipeline)
    visit pipeline_work_orders_path(pipeline)
    click_on 'Reception'
    expect(page).to have_current_path(pipeline_reception_path(pipeline))
    expect(page).to have_selector('table tr', count: 5)
    checkboxes = page.find_all('input')
    checkboxes[2].click
    checkboxes[3].click
    click_on 'Upload'
    expect(page).to have_content('Work orders were successfully uploaded')
    expect(WorkOrder.count).to eq(2)
  end

  scenario 'upload raises an error if there is an invalid work order' do
    allow(Sequencescape::Api::WorkOrder).to receive(:find_by_ids).and_raise(StandardError)
    stub :reception
    visit pipeline_work_orders_path(pipeline)
    click_on 'Reception'
    checkboxes = page.find_all('input')
    checkboxes[2].click
    checkboxes[3].click
    expect { click_on 'Upload' }.to raise_error(StandardError)
  end

  scenario 'does nothing if no work orders are selected' do
    stub :reception
    visit pipeline_work_orders_path(pipeline)
    click_on 'Reception'
    click_on 'Upload'
    expect(page).to have_content('Reception')
  end
end
