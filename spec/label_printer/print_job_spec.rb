# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::PrintJob, type: :model do
  before(:all) do
    FakeLabelTemplate = Struct.new(:id)
  end

  before(:each) do
    label_template = FakeLabelTemplate.new('1')
    allow_any_instance_of(LabelPrinter::PrintJob)
      .to receive(:find_label_template)
        .with('traction_tube_label_template') { label_template }
  end

  let!(:aliquot1) { create :aliquot, name: '123456-B12' }
  let!(:aliquot2) { create :aliquot, name: '56789-H3' }
  let(:aliquots) { [aliquot1, aliquot2] }

  it 'has printer_name' do
    print_job = LabelPrinter::PrintJob.new(printer_name: 'name')
    expect(print_job.printer_name).to eq 'name'
  end

  it 'finds tube label template id' do
    print_job = LabelPrinter::PrintJob.new
    expect(print_job.label_template_id).to eq '1'
  end

  it 'has correct labels' do
    print_job = LabelPrinter::PrintJob.new(printer_name: 'name', aliquots: aliquots)
    labels =  { body:
                [
                  { main_label:
                    { top_line: '123456',
                      middle_line: 'B12',
                      bottom_line: Date.today.strftime('%e-%^b-%Y'),
                      round_label_top_line: 'B12',
                      round_label_bottom_line: '3456',
                      barcode: aliquot1.tube_barcode } },
                  { main_label:
                    { top_line: '56789',
                      middle_line: 'H3',
                      bottom_line: Date.today.strftime('%e-%^b-%Y'),
                      round_label_top_line: 'H3',
                      round_label_bottom_line: '6789',
                      barcode: aliquots[1].tube_barcode } }
                ] }
    expect(print_job.labels).to eq labels
  end

  it 'is not valid, if it does not have aliquots, label template or printer name' do
    allow_any_instance_of(LabelPrinter::PrintJob).to receive(:find_label_template) { nil }
    print_job = LabelPrinter::PrintJob.new
    expect(print_job.valid?).to be false
    expect(print_job.errors.count).to eq 3
  end

  it 'sends print job to PrintMyBarcode if valid' do
    print_job = LabelPrinter::PrintJob.new(printer_name: 'name', aliquots: aliquots)
    attributes = { printer_name: 'name',
                   label_template_id: '1',
                   labels: { body:
                    [
                      { main_label:
                        { top_line: '123456',
                          middle_line: 'B12',
                          bottom_line: Date.today.strftime('%e-%^b-%Y'),
                          round_label_top_line: 'B12',
                          round_label_bottom_line: '3456',
                          barcode: aliquot1.tube_barcode } },
                      { main_label:
                        { top_line: '56789',
                          middle_line: 'H3',
                          bottom_line: Date.today.strftime('%e-%^b-%Y'),
                          round_label_top_line: 'H3',
                          round_label_bottom_line: '6789',
                          barcode: aliquots[1].tube_barcode } }
                    ] } }
    expect(print_job.valid?).to be true
    expect(LabelPrinter::PrintMyBarcodeApi::PrintJob).to receive(:create).with(attributes)
    print_job.execute
  end
end
