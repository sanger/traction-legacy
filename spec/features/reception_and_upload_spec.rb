# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Reception and upload', type: :feature do
  scenario 'new sqsc workorders should be on the reception page and can be uploaded' do
    work_orders = Sqsc::Api::WorkOrder.test_work_orders
    visit root_path
    click_on 'Reception'
    expect(page).to have_current_path(reception_path)
    expect(page).to have_selector('table tr', count: 5)
    page.find_all('table tr').each_with_index do |row, index|
      fields = row.find_all('td')
      expect(fields[1].text).to eq work_orders[index].name
      expect(fields[2].text).to eq work_orders[index].state
    end
    checkboxes = page.find_all('input')
    checkboxes[0].click
    checkboxes[2].click
    click_on 'Upload'
    expect(page).to have_current_path(work_orders_path)
    expect(page).to have_selector('table tr', count: 2)
    page.find_all('table tr').each_with_index do |row, index|
      fields = row.find_all('td')
      expect(fields[0].text).to eq work_orders[index * 2].name
      expect(fields[1].text).to eq 'started'
    end
    click_on 'Reception'
    expect(page).to have_selector('table tr', count: 3)
  end

  after do
    Sqsc::Api::WorkOrder.destroy_test_work_orders
  end
end
