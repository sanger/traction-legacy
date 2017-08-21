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
    attributes = { printer_name: 'abc',
                   label_template_id: '1',
                   labels: { body:
                    [{ main_label:
                      { top_line: aliquot.source_plate_barcode.to_s,
                        middle_line: aliquot.source_well_position.to_s,
                        bottom_line: '',
                        round_label_top_line: '',
                        round_label_bottom_line: '',
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
end
