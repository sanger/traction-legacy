# frozen_string_literal: true

# Aliquot
class Aliquot < ApplicationRecord
  belongs_to :sample
  belongs_to :tube
  has_one :work_order

  enum qc_state: %i[fail proceed_at_risk proceed]

  validates_presence_of :name

  delegate :barcode, to: :tube, prefix: true

  include TubeBuilder

  def self.find_by_work_orders_ids(work_orders_ids)
    joins(:work_order).where(work_orders: { id: work_orders_ids })
  end

  def source_plate_barcode
    name.split('-').first
  end

  def source_well_position
    name.split('-').last
  end

  def short_source_plate_barcode
    source_plate_barcode.split(//).last(4).join
  end
end
