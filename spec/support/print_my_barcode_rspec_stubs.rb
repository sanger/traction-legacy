# frozen_string_literal: true

module PrintMyBarcodeRspecStubs
  FakeLabelTemplate = Struct.new(:id)

  def stub_print_my_barcode
    stub_printers
    stub_label_template
    stub_print_job
  end

  def stub_printers
    allow(LabelPrinter::PrintMyBarcodeApi::Printer).to receive(:names) { %w[abc def] }
  end

  def stub_label_template
    label_template = FakeLabelTemplate.new('1')
    allow(LabelPrinter::PrintMyBarcodeApi::LabelTemplate)
      .to receive_message_chain(:where, :first) { label_template }
  end

  def stub_print_job
    allow(LabelPrinter::PrintMyBarcodeApi::PrintJob).to receive(:create) { true }
  end
end
