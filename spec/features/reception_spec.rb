# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Reception', type: :feature do
  scenario 'new sequencescape workorders should be on the reception page' do
    work_orders = Sequencescape::Api::WorkOrder.test_work_orders
    visit root_path
    click_on 'Reception'
    expect(page).to have_current_path(reception_path)
    expect(page).to have_selector('table tr', count: 5)
    page.find_all('table tr').each_with_index do |row, index|
      fields = row.find_all('td')
      expect(fields[1].text).to eq work_orders[index].name
      expect(fields[2].text).to eq work_orders[index].state
    end
  end

  scenario 'upload work orders successfully' do
    Sequencescape::Api::WorkOrder.create_test_work_orders
    visit root_path
    click_on 'Reception'
    expect(page).to have_current_path(reception_path)
    expect(page).to have_selector('table tr', count: 5)
    checkboxes = page.find_all('input')
    checkboxes[0].click
    checkboxes[1].click
    checkboxes[2].click
    checkboxes[3].click
    checkboxes[4].click
    click_on 'Upload'
    expect(page).to have_content('Work orders were successfully uploaded')
    expect(WorkOrder.count).to eq(5)
  end

  scenario 'upload raises an error if there is an invalid work order' do
    Sequencescape::Api::WorkOrder.create_invalid_test_work_orders
    visit root_path
    click_on 'Reception'
    checkboxes = page.find_all('input')
    checkboxes[0].click
    checkboxes[1].click
    checkboxes[2].click
    checkboxes[3].click
    checkboxes[4].click
    expect { click_on 'Upload' }.to raise_error(ActiveRecord::RecordInvalid)
  end

  scenario 'does nothing if no work orders are selected' do
    Sequencescape::Api::WorkOrder.create_test_work_orders
    visit root_path
    click_on 'Reception'
    click_on 'Upload'
    expect(page).to have_content('Reception')
  end

  after(:each) do
    Sequencescape::Api::WorkOrder.destroy_test_work_orders
  end
end
