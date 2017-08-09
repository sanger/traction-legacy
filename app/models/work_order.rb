# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot
  has_one :library
  has_many :events

  enum state: %i[started qc library_preparation sequencing completed]

  attr_readonly :uuid

  validates_presence_of :uuid

  accepts_nested_attributes_for :aliquot, :library

  delegate :name, to: :aliquot

  before_save :add_event

  def next_state!
    next_state = WorkOrder.states.key(WorkOrder.states[state] + 1)
    return unless next_state.present?
    update_attributes(state: next_state)
  end

  private

  def add_event
    events.build(state_from: 'none', state_to: state) if new_record?
    events.build(state_from: state_was, state_to: state) if state_changed?
  end
end
