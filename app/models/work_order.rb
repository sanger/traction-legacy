# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot

  has_many :work_order_requirements

  attr_readonly :sequencescape_id, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :study_uuid, :sample_uuid

  accepts_nested_attributes_for :aliquot, :work_order_requirements

  delegate :name, :source_plate_barcode, :source_well_position, :action,
           :short_source_plate_barcode, :receptacle_barcode, :lab_events, to: :aliquot
  delegate :state, :next_state, to: :aliquot, prefix: true

  scope :by_date, (-> { order(created_at: :desc) })

  def self.by_aliquot_state(aliquot_state)
    return all unless aliquot_state.present?
    select { |work_order| work_order.aliquot_state == aliquot_state.to_s }
  end

  def self.by_aliquot_next_state(aliquot_next_state)
    return all unless aliquot_next_state.present?
    select { |work_order| work_order.aliquot_next_state == aliquot_next_state.to_s }
  end

  def unique_name
    "#{id}:#{name}"
  end

  def details
    @details ||= OpenStruct.new(work_order_requirements.collect(&:to_h).inject(:merge!))
  end

  def went_through_step(step_name)
    aliquot.lab_event?(step_name)
  end

  def create_sequencing_event(state)
    aliquot.create_sequencing_event(state)
  end

  def remove_sequencing_event
    aliquot.destroy_sequencing_events
  end
end
