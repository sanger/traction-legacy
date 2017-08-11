# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Upload', type: :feature do
  include WebmockHelpers

  scenario 'new sequencescape workorders can be uploaded' do
    stub :reception
    stub :successful_upload
    stub_updates
    work_orders = Sequencescape::Api::WorkOrder.for_reception
    visit root_path
    click_on 'Reception'
    expect(page).to have_current_path(reception_path)
    expect(page).to have_selector('table tr', count: 5)
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
  end

end
