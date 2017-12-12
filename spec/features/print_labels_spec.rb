# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Print labels', type: :feature do
  before(:all) do
    create :gridion_pipeline
  end

  let!(:work_orders)  { create_list(:gridion_work_order, 5) }
  let!(:work_order)   { work_orders.first }
  let!(:printers)     { create_list(:printer, 5) }
  let!(:pipeline)     { Pipeline.first }

  scenario 'Can print several tube labels from work orders index page' do
    allow(PMB::PrintJob).to receive(:execute) { true }
    visit pipeline_work_orders_path(pipeline)
    checkboxes = page.find_all('input')
    checkboxes[2].click
    checkboxes[3].click
    select printers.first.name, from: :printer_name
    click_on 'Print labels'
    expect(page).to have_content(I18n.t('printing.success'))
  end

  scenario 'Shows error if print job is not successful' do
    allow(PMB::PrintJob).to receive(:execute).and_raise(
      JsonApiClient::Errors::ServerError.new(Rails.env)
    )
    visit pipeline_work_orders_path(pipeline)
    checkboxes = page.find_all('input')
    checkboxes[2].click
    checkboxes[3].click
    select printers.first.name, from: :printer_name
    click_on 'Print labels'
    expect(page).to have_content(I18n.t('printing.failure'))
  end

  scenario 'does nothing if no work orders are selected' do
    visit pipeline_work_orders_path(pipeline)
    select printers.first.name, from: :printer_name
    click_on 'Print labels'
    expect(page).to have_content('Please select some work orders!')
  end
end
