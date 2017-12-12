# frozen_string_literal: true

# WorkOrder
class WorkOrder < ApplicationRecord
  belongs_to :aliquot

  has_many :work_order_requirements

  attr_readonly :sequencescape_id, :study_uuid, :sample_uuid

  validates_presence_of :sequencescape_id, :study_uuid, :sample_uuid

  accepts_nested_attributes_for :aliquot, :work_order_requirements

  delegate_missing_to :aliquot
  delegate :state, :next_state, to: :aliquot, prefix: true

  scope :by_date, (-> { order(created_at: :desc) })

  # returns an array of work_orders in particular state within pipeline
  def self.by_pipeline_and_aliquot_state(pipeline, aliquot_state = nil)
    all_work_orders_in_pipeline = work_orders_in_pipeline(pipeline)
    if aliquot_state.present?
      all_work_orders_in_pipeline.select { |work_order| work_order.aliquot_state == aliquot_state.to_s }
    else
      all_work_orders_in_pipeline
    end
  end

  # returns an array of work_orders with particular next state within pipeline
  def self.by_pipeline_and_aliquot_next_state(pipeline, aliquot_next_state = nil)
    all_work_orders_in_pipeline = work_orders_in_pipeline(pipeline)
    if aliquot_next_state.present?
      all_work_orders_in_pipeline.select { |work_order| work_order.aliquot_next_state == aliquot_next_state.to_s }
    else
      all_work_orders_in_pipeline
    end
  end

  # returns an array of all work_orders within pipeline
  def self.work_orders_in_pipeline(pipeline)
    select { |work_order| work_order.pipeline == pipeline }
  end

  def unique_name
    "#{id}:#{name}"
  end

  # this is work_order requirements
  # they are different for different pipelines
  # OpenStruct is used to be able to call a method with requirement name
  # example work_order.details.number_of_flowcells
  # TODO think about refactoring it
  def details
    @details ||= OpenStruct.new(work_order_requirements.collect(&:to_h).inject(:merge!))
  end

  def went_through_step(step_name)
    aliquot.lab_event?(step_name)
  end
end
