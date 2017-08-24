# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Print labels', type: :feature do

  let!(:work_orders)  { create_list(:work_order, 5) }
  let!(:work_order)   { work_orders.first }
  let!(:printers)     { create_list(:printer, 5)}

  scenario 'Can print several tube labels from work orders index page' do
    allow(PMB::PrintJob).to receive(:execute) { true }
    visit work_orders_path
    checkboxes = page.find_all('input')
    checkboxes[2].click
    checkboxes[3].click
    select printers.first.name, from: :printer_name
    click_on 'Print labels'
    expect(page).to have_content("Your label(s) have been sent to printer #{printers.first.name}")
  end

  scenario 'Shows error if print job is not valid' do
    allow(PMB::PrintJob).to receive(:execute) { true }
    visit work_orders_path
    select printers.first.name, from: :printer_name
    click_on 'Print labels'
    expect(page).to have_content("Aliquots can't be blank")
  end
end
