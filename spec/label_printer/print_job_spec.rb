# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::PrintJob, type: :model do
  let!(:work_orders)    { create_list(:work_order, 5) }
  let(:work_order_ids)  { work_orders.collect(&:id) }
  let(:printer)         { build(:printer) }
  let(:attributes)      do
    { printer_name: printer.name, label_template_id: 1,
      labels: LabelPrinter::Labels.new(WorkOrder.find(work_order_ids)).to_h }
  end

  it 'if the printing is successful returns an appropriate message' do
    allow(PMB::PrintJob).to receive(:execute).with(attributes).and_return(true)
    label_printer = LabelPrinter::PrintJob.new(printer_name: printer.name,
                                               label_template_id: 1, work_orders: work_order_ids)
    expect(label_printer.post).to be_truthy
    expect(label_printer.message).to eq(I18n.t('printing.success'))
  end

  it 'if the printing is unsuccessful should return an appropriate message' do
    allow(PMB::PrintJob).to receive(:execute).and_raise(
      JsonApiClient::Errors::ServerError.new(Rails.env)
    )
    label_printer = LabelPrinter::PrintJob.new(printer_name: printer.name,
                                               label_template_id: 1, work_orders: work_order_ids)
    expect(label_printer.post).to be_falsey
    expect(label_printer.message).to eq(I18n.t('printing.failure'))
  end
end
