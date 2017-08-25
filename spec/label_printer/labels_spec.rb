# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::Labels, type: :model do
  let!(:work_orders)  { create_list(:work_order, 2) }
  let(:labels)        { LabelPrinter::Labels.new(work_orders) }

  before(:each) do
    allow(Date).to receive(:today).and_return(Date.parse('Thu, 24 Aug 2017'))
  end

  it 'must have two labels' do
    expect(labels.to_h[:body].count).to eq(2)
  end

  it 'each label must have the correct attributes' do
    label = labels.to_h[:body].first[:main_label]
    work_order = work_orders.first
    expect(label[:first_line]).to eq('ONT')
    expect(label[:second_line]).to eq(work_order.source_plate_barcode)
    expect(label[:third_line]).to eq(work_order.source_well_position)
    expect(label[:fourth_line]).to eq(Date.today.to_s(:label))
    expect(label[:round_label_top_line]).to eq(work_order.source_well_position)
    expect(label[:round_label_bottom_line]).to eq(work_order.short_source_plate_barcode)
    expect(label[:barcode]).to eq(work_order.tube_barcode)
  end
end
