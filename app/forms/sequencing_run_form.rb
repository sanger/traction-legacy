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
    @created = self.sequencing_run.new_record?
  end

  def submit(params)
    sequencing_run.assign_attributes(params)
    if valid?
      persist_sequencing_run
      send_bunny_messages if created?
      true
    else
      false
    end
  end

  def persist_sequencing_run
    ActiveRecord::Base.transaction do
      sequencing_run.save
      sequencing_run.reload
      update_work_orders
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
    work_orders = WorkOrder.includes(:aliquot).by_aliquot_state(:library_preparation)
    return work_orders if sequencing_run.new_record?
    (work_orders.to_a << sequencing_run.work_orders).flatten.uniq
  end

  def created?
    @created
  end

  def send_bunny_messages
    sequencing_run.flowcells.each do |flowcell|
      Messages::Exchange.connection << Messages::OseqFlowcell.new(flowcell)
    end
  end

  private

  def update_work_orders
    # does not create lab event or update sequencescape if not completed
    # I took it from tests, is it a requirement?
    return unless sequencing_run.pending? || sequencing_run.completed?
    sequencing_run.work_orders.each do |work_order|
      work_order.manage_sequencing_state(sequencing_run)
    end
  end

  def check_sequencing_run
    return if sequencing_run.valid?
    sequencing_run.errors.each do |key, value|
      errors.add(key, value)
    end
  end
end
