# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot
  has_many :events
  has_many :flowcells, inverse_of: :work_order

  enum state: %i[started qc library_preparation sequencing completed]

  attr_readonly :sequencescape_id, :library_preparation_type, :data_type,
                :number_of_flowcells, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :library_preparation_type,
                        :data_type, :number_of_flowcells,
                        :study_uuid, :sample_uuid

  accepts_nested_attributes_for :aliquot

  delegate :name, :source_plate_barcode,
           :source_well_position, :short_source_plate_barcode, to: :aliquot

  scope :by_state, (->(state) { where(state: WorkOrder.states[state.to_s]) })
  scope :by_date, (-> { order(created_at: :desc) })

  after_touch :back_to_library_preparation, if: :removed_from_sequencing?

  def next_state
    WorkOrder.states.key(WorkOrder.states[state] + 1)
  end

  def editable?
    started? || qc?
  end

  def assign_state(state)
    assign_attributes(state: WorkOrder.states[state.to_s])
  end

  def unique_name
    "#{id}:#{name}"
  end

  private

  def back_to_library_preparation
    library_preparation!
    Sequencescape::Api::WorkOrder.update_state(self)
  end

  def removed_from_sequencing?
    sequencing? && flowcells.empty?
  end
end
