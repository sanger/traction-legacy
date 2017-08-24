# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::PrintJob, type: :model do
  let!(:aliquot1) { create :aliquot, name: '123456:B12' }
  let!(:aliquot2) { create :aliquot, name: '56789:H3' }
  let(:aliquots) { [aliquot1, aliquot2] }

  context 'Print my barcode is up and running' do
   
    it 'has printer_name' do
      print_job = LabelPrinter::PrintJob.new(printer_name: 'name')
      expect(print_job.printer_name).to eq 'name'
    end

    it 'has correct labels' do
      print_job = LabelPrinter::PrintJob.new(printer_name: 'name', label_template_id: 112, aliquots: aliquots)
      expect(print_job.labels[:body].count).to eq 2
    end

    it 'is not valid, if it does not have aliquots, label template or printer name' do
      print_job = LabelPrinter::PrintJob.new
      expect(print_job.valid?).to be false
      expect(print_job.errors.count).to eq 3
    end

    it 'sends print job to PrintMyBarcode if valid' do
      print_job = LabelPrinter::PrintJob.new(printer_name: 'name', label_template_id: 112, aliquots: aliquots)
      attributes = { printer_name: 'name',
                     label_template_id: 112,
                     labels: { body:
                      [
                        { main_label:
                          { first_line: 'ONT',
                            second_line: '123456',
                            third_line: 'B12',
                            fourth_line: Date.today.strftime('%e-%^b-%Y'),
                            round_label_top_line: 'B12',
                            round_label_bottom_line: '3456',
                            barcode: aliquot1.tube_barcode } },
                        { main_label:
                          { first_line: 'ONT',
                            second_line: '56789',
                            third_line: 'H3',
                            fourth_line: Date.today.strftime('%e-%^b-%Y'),
                            round_label_top_line: 'H3',
                            round_label_bottom_line: '6789',
                            barcode: aliquot2.tube_barcode } }
                      ] } }
      expect(print_job.valid?).to be true
      expect(PMB::PrintJob).to receive(:execute).with(attributes)
      print_job.execute
    end
  end

  context 'Print my barcode is down' do
  
    it 'execute should return false if print my barcode is down' do
      allow(PMB::PrintJob)
        .to receive(:execute)
        .and_raise(JsonApiClient::Errors::ServerError.new(Rails.env))
      print_job = LabelPrinter::PrintJob.new(printer_name: 'name', label_template_id: 112, aliquots: aliquots)
      expect(print_job.execute).to eq false
    end
  end
end
