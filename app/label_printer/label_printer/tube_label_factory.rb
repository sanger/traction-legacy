# frozen_string_literal: true

module LabelPrinter
  # generates tube labels
  class TubeLabelFactory
    include ActiveModel::Model

    attr_reader :aliquots

    def self.generate_labels(aliquots)
      new(aliquots).generate_labels
    end

    def initialize(aliquots)
      @aliquots = aliquots || []
    end

    def generate_labels
      { body: create_labels }
    end

    def create_labels
      aliquots.map do |aliquot|
        { main_label: { first_line: 'ONT',
                        second_line: aliquot.source_plate_barcode,
                        third_line: aliquot.source_well_position,
                        fourth_line: Date.today.to_s(:label),
                        round_label_top_line: aliquot.source_well_position,
                        round_label_bottom_line: aliquot.short_source_plate_barcode,
                        barcode: aliquot.tube_barcode } }
      end
    end
  end
end
