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
        { main_label: { top_line: aliquot.source_plate_barcode,
                        middle_line: aliquot.source_well_position,
                        bottom_line: '',
                        round_label_top_line: '',
                        round_label_bottom_line: '',
                        barcode: aliquot.tube_barcode } }
      end
    end
  end
end
