# frozen_string_literal: true

# WorkOrderForm
class SequencingRunForm
  include ActiveModel::Model

  MAX_FLOWCELLS = 5

  attr_reader :sequencing_run

  validate :check_sequencing_run

  delegate_missing_to :sequencing_run

  def initialize(sequencing_run = nil)
    @sequencing_run = sequencing_run || SequencingRun.new
  end

  def submit(params)
    sequencing_run.assign_attributes(params)
    if valid?
      ActiveRecord::Base.transaction do
        sequencing_run.save
        update_work_orders
      end
      true
    else
      false
    end
  end

  def flowcells_by_position
    [].tap do |f|
      (1..MAX_FLOWCELLS).each do |i|
        f << (sequencing_run.flowcells.detect { |o| o.position == i } || Flowcell.new(position: i))
      end
    end
  end

  def self.model_name
    ActiveModel::Name.new(SequencingRun)
  end

  def persisted?
    sequencing_run.id?
  end

  def available_work_orders
    work_orders = WorkOrder.by_state(:library_preparation)
    return work_orders if sequencing_run.new_record?
    (work_orders.to_a << sequencing_run.work_orders).flatten.uniq
  end

  private

  # TODO: code smell. State changes and their consequences should be managed centrally
  # within a workflow.
  def update_work_orders
    sequencing_run.work_orders.each do |work_order|
      if sequencing_run.pending?
        update_work_order_state(work_order, :sequencing)
      elsif sequencing_run.completed?
        update_work_order_state(work_order, :completed)
      end
    end
  end

  def update_work_order_state(work_order, state)
    work_order.send("#{state}!")
    Sequencescape::Api::WorkOrder.update_state(work_order)
  end

  def check_sequencing_run
    return if sequencing_run.valid?
    sequencing_run.errors.each do |key, value|
      errors.add(key, value)
    end
  end
end
