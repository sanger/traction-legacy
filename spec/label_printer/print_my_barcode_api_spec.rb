# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::PrintMyBarcodeApi::Printer, type: :model do
  it 'has should return printers names' do
    printers = [LabelPrinter::PrintMyBarcodeApi::Printer.new(name: 'name1'),
                LabelPrinter::PrintMyBarcodeApi::Printer.new(name: 'name2')]
    allow(LabelPrinter::PrintMyBarcodeApi::Printer).to receive(:all) { printers }
    printers_names = LabelPrinter::PrintMyBarcodeApi::Printer.names
    expect(printers_names).to eq %w[name1 name2]
  end

  it 'if print my barcode is down, it should return empty array instead of printers names' do
    allow(LabelPrinter::PrintMyBarcodeApi::Printer)
      .to receive(:all)
      .and_raise(JsonApiClient::Errors::ConnectionError.new(Rails.env))
    printers_names = LabelPrinter::PrintMyBarcodeApi::Printer.names
    expect(printers_names).to eq []
  end
end
