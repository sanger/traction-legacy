# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Upload', type: :feature do
  scenario 'new sequencescape workorders can be uploaded if valid' do
    work_orders = Sequencescape::Api::WorkOrder.create_invalid_test_work_orders
    visit root_path
    click_on 'Reception'
    expect(page).to have_current_path(reception_path)
    expect(page).to have_selector('table tr', count: 5)
    checkboxes = page.find_all('input')
    checkboxes[0].click
    checkboxes[1].click
    checkboxes[2].click
    click_on 'Upload'
    expect(page).to have_current_path(reception_path)
    expect(page).to have_content("Work orders with ids no_id were not found in Sequencescape, please contact PSD. Work orders #{work_orders[1].id} are not ready to be uploaded, please contact PSD") # rubocop:disable all
    checkboxes = page.find_all('input')
    checkboxes[2].click
    checkboxes[3].click
    click_on 'Upload'
    expect(page).to have_current_path(work_orders_path)
    expect(page).to have_content('Work orders were successfully uploaded')
    expect(page).to have_selector('table tr', count: 2)
    page.find_all('table tr').each_with_index do |row, index|
      fields = row.find_all('td')
      expect(fields[0].text).to eq work_orders[index + 2].name
      expect(fields[1].text).to eq 'started'
    end
    click_on 'Reception'
    expect(page).to have_selector('table tr', count: 3)
  end

  after do
    Sequencescape::Api::WorkOrder.destroy_test_work_orders
  end
end
