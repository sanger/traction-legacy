# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Print labels', type: :feature do
  include PrintMyBarcodeRspecStubs

  let!(:work_orders)  { create_list(:work_order, 5) }
  let!(:work_order)   { work_orders.first }

  scenario 'Can print tube label from work order show page' do
    stub_printers
    stub_label_template
    aliquot = work_order.aliquot
    aliquot.name = '12345-A1'
    aliquot.save
    attributes = { printer_name: 'abc',
                   label_template_id: '1',
                   labels: { body:
                    [{ main_label:
                      { top_line: '12345',
                        middle_line: 'A1',
                        bottom_line: Date.today.strftime('%e-%^b-%Y'),
                        round_label_top_line: 'A1',
                        round_label_bottom_line: '2345',
                        barcode: aliquot.tube_barcode.to_s } }] } }
    allow(LabelPrinter::PrintMyBarcodeApi::PrintJob).to receive(:create).with(attributes) { true }

    visit work_order_path(work_order)
    select 'abc', from: :printer_name
    click_on 'Print label'
    expect(page).to have_content('Your label(s) have been sent to printer abc')
  end

  scenario 'Shows error if print job not valid' do
    stub_label_template
    allow(LabelPrinter::PrintMyBarcodeApi::Printer).to receive(:names) { [] }

    visit work_order_path(work_order)
    click_on 'Print label'
    expect(page).to have_content("Printer name can't be blank")
  end

  scenario 'Can print several tube labels from work orders index page' do
    stub_print_my_barcode
    visit work_orders_path
    checkboxes = page.find_all('input')
    checkboxes[2].click
    checkboxes[3].click
    select 'abc', from: :printer_name
    click_on 'Print labels'
    expect(page).to have_content('Your label(s) have been sent to printer abc')
  end
end
