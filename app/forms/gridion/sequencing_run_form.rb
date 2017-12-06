# frozen_string_literal: true

module Gridion
  # SequencingRunForm
  class SequencingRunForm
    include ActiveModel::Model

    MAX_FLOWCELLS = 5

    attr_reader :sequencing_run

    validate :check_sequencing_run

    delegate_missing_to :sequencing_run

    def initialize(sequencing_run = nil)
      @sequencing_run = sequencing_run || SequencingRun.new
      @created = self.sequencing_run.new_record?
      @old_state = @sequencing_run.state
      @old_work_orders = @sequencing_run.work_orders.uniq
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

    def work_orders_to_be_updated
      return sequencing_run.work_orders.uniq if @created
      return sequencing_run.work_orders.uniq if state_changed?
      new_work_orders
    end

    private

    def update_work_orders
      removed_work_orders.each(&:remove_sequencing_event)
      # does not create lab event or update sequencescape if not completed
      # I took it from tests, is it a requirement?
      return unless sequencing_run.pending? || sequencing_run.completed?
      work_orders_to_be_updated.each do |work_order|
        work_order.create_sequencing_event(sequencing_run.result)
      end
    end

    def check_sequencing_run
      return if sequencing_run.valid?
      sequencing_run.errors.each do |key, value|
        errors.add(key, value)
      end
    end

    def state_changed?
      @old_state != sequencing_run.state
    end

    def new_work_orders
      sequencing_run.work_orders.uniq - @old_work_orders
    end

    def removed_work_orders
      @old_work_orders - sequencing_run.work_orders.uniq
    end
  end
end
