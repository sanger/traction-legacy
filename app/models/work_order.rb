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

  delegate :sample, to: :aliquot
  delegate :name, to: :sample, prefix: true

  before_save :add_event

  def next_state!
    next_state = WorkOrder.states.key(WorkOrder.states[state] + 1)
    return unless next_state.present?
    ActiveRecord::Base.transaction do
      update_attributes(state: next_state)
      update_sqsc_state
    end
  end

  private

  def add_event
    events.build(state_from: 'none', state_to: state) if new_record?
    events.build(state_from: state_was, state_to: state) if state_changed?
  end

  # should it be here?
  def update_sqsc_state
    # sqsc work order does not have uuid yet, so for now traction uuid id sequincescape id
    sqsc_work_order = Sqsc::Api::WorkOrder.find_by_id(uuid)
    sqsc_work_order.update_state_to(state)
  end
end
