# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot
  has_one :library
  has_many :events
  has_many :flowcells, inverse_of: :work_order

  enum state: %i[started qc library_preparation sequencing completed]

  attr_readonly :sequencescape_id, :library_preparation_type, :data_type,
                :number_of_flowcells, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :library_preparation_type,
                        :data_type, :number_of_flowcells,
                        :study_uuid, :sample_uuid

  validate :maximum_number_of_flowcells

  accepts_nested_attributes_for :aliquot, :library

  delegate :name, to: :aliquot

  scope :by_state, (->(state) { where(state: WorkOrder.states[state.to_s]) })
  scope :by_date, (-> { order(created_at: :desc) })

  before_save :add_event

  def next_state
    WorkOrder.states.key(WorkOrder.states[state] + 1)
  end

  def library?
    library.present?
  end

  def editable?
    started? || qc?
  end

  def assign_state(state)
    assign_attributes(state: WorkOrder.states[state.to_s])
  end

  private

  def add_event
    events.build(state_from: 'none', state_to: state) if new_record?
    events.build(state_from: state_was, state_to: state) if state_changed?
  end

  def maximum_number_of_flowcells
    return unless number_of_flowcells.present?
    return unless flowcells.length > number_of_flowcells
    errors.add(:flowcells, "number must not exceed #{number_of_flowcells}")
  end
end
