# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot

  has_many :flowcells, inverse_of: :work_order
  has_many :work_order_requirements

  attr_readonly :sequencescape_id, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :study_uuid, :sample_uuid

  accepts_nested_attributes_for :aliquot, :work_order_requirements

  delegate :name, to: :aliquot
  delegate :state, to: :aliquot, prefix: true
  delegate :number_of_flowcells, :data_type, :library_preparation_type, to: :details

  scope :by_date, (-> { order(created_at: :desc) })

  def self.by_aliquot_state(aliquot_state)
    select { |work_order| work_order.aliquot_state == aliquot_state.to_s }
  end

  def unique_name
    "#{id}:#{name}"
  end

  def details
    @details ||= OpenStruct.new(work_order_requirements.collect(&:to_h).inject(:merge!))
  end

  def manage_sequencing_state(sequencing_run)
    aliquot.create_sequencing_event(sequencing_run.result)
    update_state_in_sequencescape(sequencing_run.result)
  end

  def update_state_in_sequencescape(state = nil)
    Sequencescape::Api::WorkOrder.update_state(self, state)
  end

  private

  def removed_from_sequencing?
    sequencing? && flowcells.empty?
  end
end
