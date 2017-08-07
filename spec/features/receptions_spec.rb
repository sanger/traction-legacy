# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Reception', type: :feature do
  scenario 'new sqsc workorders should be on the page' do
    Sqsc::Api::WorkOrder = Sqsc::Api::FakeWorkOrder
    work_orders = Sqsc::Api::WorkOrder.for_reception
    visit root_path
    click_on 'Reception'
    expect(page).to have_selector('table tr', count: 5)
    page.find_all('table tr').each_with_index do |row, index|
      fields = row.find_all('td')
      expect(fields[1].text).to eq work_orders[index].name
      expect(fields[2].text).to eq work_orders[index].state
    end
  end

end
