# frozen_string_literal: true

# Aliquot
class Aliquot < ApplicationRecord
  has_one :work_order
  has_many :lab_events
  belongs_to :parent, class_name: 'Aliquot', optional: true

  validates_presence_of :name

  def self.find_by_work_orders_ids(work_orders_ids)
    joins(:work_order).where(work_orders: { id: work_orders_ids })
  end

  def metadata
    @metadata ||= {}.tap do |result|
      lab_events.each_with_index do |lab_event, i|
        result["step#{i + 1} #{lab_event.name}"] = lab_event.metadata
      end
    end
  end

  def source_plate_barcode
    name.split(':').first
  end

  def source_well_position
    name.split(':').last
  end

  def short_source_plate_barcode
    source_plate_barcode.split(//).last(4).join
  end

  def current_process_step
    lab_events.last_process_step
  end

  def current_process_step_name
    current_process_step.try(:name) || 'started'
  end
  alias state current_process_step_name

  def next_process_step_name(pipeline)
    pipeline.next_process_step(current_process_step).try(:name)
  end
end
