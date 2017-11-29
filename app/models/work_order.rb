# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot

  has_many :flowcells, inverse_of: :work_order
  has_many :work_order_requirements

  # state is not used for now, we report to sequencescape based on aliquot state for now
  enum state: %i[started sequencing completed failed]

  attr_readonly :sequencescape_id, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :study_uuid, :sample_uuid

  accepts_nested_attributes_for :aliquot, :work_order_requirements

  delegate :name, to: :aliquot
  delegate :state, to: :aliquot, prefix: true
  delegate :number_of_flowcells, :data_type, :library_preparation_type, to: :details

  scope :by_state, (->(state) { where(state: WorkOrder.states[state.to_s]) })
  scope :by_date, (-> { order(created_at: :desc) })

  def self.by_aliquot_state(aliquot_state)
    select { |work_order| work_order.aliquot_state == aliquot_state.to_s }
  end

  def assign_state(state)
    assign_attributes(state: WorkOrder.states[state.to_s])
  end

  def editable?
    started?
  end

  def unique_name
    "#{id}:#{name}"
  end

  def details
    @details ||= OpenStruct.new(work_order_requirements.collect(&:to_h).inject(:merge!))
  end

  private

  def removed_from_sequencing?
    sequencing? && flowcells.empty?
  end
end
