# frozen_string_literal: true

module Gridion
  # SequencingRunForm is a service object, it deals with gridion sequencing_run form:
  # - it creates/updates gridion sequencing_run
  # - it moves work_order/aliquot to/from sequencing state (#update_work_orders)
  # - it sends bunny messages
  class SequencingRunForm
    include ActiveModel::Model

    MAX_FLOWCELLS = 5

    attr_reader :sequencing_run

    validate :check_sequencing_run

    delegate_missing_to :sequencing_run

    # when initialized, it remembers the state and work_orders of sequencing_run
    # before changes are made
    # it is needed to find out what work orders were added to sequencing run (#new_work_orders)
    # and what work orders were removed from sequencing run (#removed_work_orders)
    def initialize(sequencing_run = nil)
      @sequencing_run = sequencing_run || SequencingRun.new
      @created = self.sequencing_run.new_record?
      @old_state = @sequencing_run.state
      @old_work_orders = @sequencing_run.work_orders.uniq
      @pipeline = Pipeline.find_by(name: 'grid_ion')
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

    # returns an array of work_orders available for sequencing
    # they appear in select drop down for each flowcell
    def available_work_orders
      work_orders = WorkOrder.includes(aliquot: { lab_events: { process_step: :pipeline } })
                             .by_pipeline_and_aliquot_state(@pipeline, :library_preparation)
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

    def check_sequencing_run
      return if sequencing_run.valid?
      sequencing_run.errors.each do |key, value|
        errors.add(key, value)
      end
    end

    # TODO: create(destroy) lab events from one place

    # work_orders that were removed from sequencing run go to
    # previous step (sequencing events will be removed)
    # then if sequencing run is failed nothing happens (I took it from tests, is it a requirement?)
    # if sequencing run is pending or completed,
    # work_orders are updated (respective lab event is created and sequencescape is updated)
    def update_work_orders
      removed_work_orders.each do |work_order|
        work_order.aliquot.destroy_sequencing_events
      end
      return unless sequencing_run.pending? || sequencing_run.completed?
      work_orders_to_be_updated.each do |work_order|
        work_order.aliquot.create_sequencing_event(sequencing_run.result)
      end
    end

    # returns a list of work_orders that should be updated
    # (either moved to sequencing or sequencing state should be updated)
    def work_orders_to_be_updated
      return sequencing_run.work_orders.uniq if @created
      return sequencing_run.work_orders.uniq if state_changed?
      new_work_orders
    end

    def state_changed?
      @old_state != sequencing_run.state
    end

    # returns an array of work_orders that were added to sequencing_run
    def new_work_orders
      sequencing_run.work_orders.uniq - @old_work_orders
    end

    # returns an array of work_orders that were removed from sequencing_run
    def removed_work_orders
      @old_work_orders - sequencing_run.work_orders.uniq
    end
  end
end
