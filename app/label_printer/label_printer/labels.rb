# frozen_string_literal: true

module LabelPrinter
  # Labels
  class Labels
    attr_reader :work_orders

    def initialize(work_orders)
      @work_orders = Array(work_orders)
    end

    def to_h
      {
        body: body
      }
    end

    def body
      work_orders.map do |work_order|
        {
          main_label: main_label(work_order)
        }
      end
    end

    def main_label(work_order)
      {
        first_line: 'ONT',
        second_line: work_order.source_plate_barcode,
        third_line: work_order.source_well_position,
        fourth_line: Date.today.to_s(:label),
        round_label_top_line: work_order.source_well_position,
        round_label_bottom_line: work_order.short_source_plate_barcode,
        barcode: work_order.tube_barcode
      }
    end
  end
end
