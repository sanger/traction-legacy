# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot

  has_many :flowcells, inverse_of: :work_order
  has_many :work_order_requirements

  enum state: %i[started completed failed]

  attr_readonly :sequencescape_id, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :study_uuid, :sample_uuid

  accepts_nested_attributes_for :aliquot

  delegate :name, to: :aliquot

  scope :by_state, (->(state) { where(state: WorkOrder.states[state.to_s]) })
  scope :by_date, (-> { order(created_at: :desc) })

  def assign_state(state)
    assign_attributes(state: WorkOrder.states[state.to_s])
  end

  def editable?
    started?
  end

  def unique_name
    "#{id}:#{name}"
  end

  private

  def removed_from_sequencing?
    sequencing? && flowcells.empty?
  end
end
