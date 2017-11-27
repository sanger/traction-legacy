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

  def source_plate_barcode
    name.split(':').first
  end

  def source_well_position
    name.split(':').last
  end

  def short_source_plate_barcode
    source_plate_barcode.split(//).last(4).join
  end

  def last_lab_event_with_process_step
    lab_events.last_with_process_step
  end

  def current_process_step_name
    last_lab_event_with_process_step.try(:process_step_name) || 'not started'
  end

  def next_process_step
    return unless last_lab_event_with_process_step.present?
    last_lab_event_with_process_step.next_process
  end

  def next_process_step_name
    next_process_step.try(:name)
  end
end
