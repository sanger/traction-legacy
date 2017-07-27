# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot
  has_one :library

  TEMPLATES = %w[aliquot library sequencing completed show].freeze

  enum state: %i[started qc library_preparation sequencing completed]

  attr_readonly :uuid

  validates_presence_of :uuid

  accepts_nested_attributes_for :aliquot, :library

  delegate :sample, to: :aliquot
  delegate :name, to: :sample, prefix: true

  def next_state!
    next_state = WorkOrder.states.key(WorkOrder.states[state] + 1)
    return unless next_state.present?
    update_attributes(state: next_state)
  end

  def template
    TEMPLATES[WorkOrder.states[state]]
  end
end
