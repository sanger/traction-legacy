# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Reception and upload', type: :feature do
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

  after do
    Sequencescape::Api::WorkOrder.destroy_test_work_orders
  end
end
