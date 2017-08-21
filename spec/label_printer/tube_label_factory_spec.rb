# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::TubeLabelFactory, type: :model do
  it 'generates labels' do
    aliquots = create_list(:aliquot, 3)
    labels = LabelPrinter::TubeLabelFactory.generate_labels(aliquots)[:body]
    expect(labels.count).to eq 3
    labels.each_with_index do |list, id|
      expect(list[:main_label][:top_line]).to eq aliquots[id].source_plate_barcode
      expect(list[:main_label][:middle_line]).to eq aliquots[id].source_well_position
      expect(list[:main_label][:round_label_top_line]).to eq aliquots[id].source_well_position
    end
  end
end
