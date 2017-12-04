# frozen_string_literal: true

# Lab Event - anything that happens with aliquot in a lab
class LabEvent < ApplicationRecord
  # we do not have receptacle for sequencing process step,
  # we can make it flowcell, but for now I left it optional
  belongs_to :receptacle, optional: true
  belongs_to :aliquot
  belongs_to :process_step, optional: true
  has_many :metadata_items, validate: false

  validate :metadata_items_valid?

  enum state: %i[process_started transferred completed failed]

  after_create :update_sequencescape, if: :process_step_present?

  def metadata
    @metadata ||= (metadata_items.with_metadata_fields.collect(&:to_h).inject(:merge!) || {})
  end

  def name
    process_step.name if process_step.present?
  end

  def work_order_id=(work_order_id)
    self.aliquot = WorkOrder.find(work_order_id).aliquot
    self.receptacle = aliquot.receptacle
  end

  def metadata_items_attributes=(metadata_items_attributes)
    metadata_items_attributes.each do |key, value|
      metadata_field = process_step.find_metadata_field(key)
      metadata_items.build(metadata_field: metadata_field, value: value)
    end
  end

  def metadata_items_valid?
    metadata_items.each do |item|
      errors.add(:base, item.errors.full_messages.join(', ')) unless item.valid?
    end
  end

  def update_sequencescape
    aliquot.update_state_in_sequencescape
  end

  def process_step_present?
    process_step.present?
  end
end
