# frozen_string_literal: true

# Lab Event - anything that happens with aliquot in a lab
class LabEvent < ApplicationRecord
  belongs_to :receptacle
  belongs_to :aliquot
  belongs_to :process_step, optional: true
  has_many :metadata_items

  enum action: %i[aliquot_transferred process_started process_ended stored]

  scope :with_process_steps, (-> { where.not(process_step_id: nil) })

  delegate :name, to: :process_step, prefix: true
  delegate :pipeline, to: :process_step

  def self.last_with_process_step
    with_process_steps.last
  end

  def metadata
    @metadata ||= (metadata_items.includes(:metadata_field).collect(&:to_h).inject(:merge!) || {})
  end

  def next_process
    pipeline.next_process(process_step)
  end
end
