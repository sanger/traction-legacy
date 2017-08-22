# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::TubeLabelFactory, type: :model do
  it 'generates labels' do
    aliquot1 = create :aliquot, name: '123456:B12'
    aliquot2 = create :aliquot, name: '56789:H3'
    aliquot3 = create :aliquot, name: '456789:H12'
    aliquots = [aliquot1, aliquot2, aliquot3]
    labels = { body:
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
                      barcode: aliquot2.tube_barcode } },
                  { main_label:
                    { first_line: 'ONT',
                      second_line: '456789',
                      third_line: 'H12',
                      fourth_line: Date.today.strftime('%e-%^b-%Y'),
                      round_label_top_line: 'H12',
                      round_label_bottom_line: '6789',
                      barcode: aliquot3.tube_barcode } }
                ] }

    expect(LabelPrinter::TubeLabelFactory.generate_labels(aliquots)).to eq labels
  end
end
