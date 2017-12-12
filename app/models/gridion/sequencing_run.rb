# frozen_string_literal: true

module Gridion
  # Gridion SequencingRun
  class SequencingRun < ApplicationRecord
    has_many :flowcells, inverse_of: :sequencing_run,
                         foreign_key: :gridion_sequencing_run_id
    has_many :work_orders, through: :flowcells

    enum state: %i[pending completed user_terminated instrument_crashed restart]

    validates_presence_of :instrument_name

    accepts_nested_attributes_for :flowcells,
                                  reject_if: proc { |attributes| attributes['work_order_id'].blank? },
                                  allow_destroy: true

    scope :by_date, (-> { order(created_at: :desc) })

    with_options if: :flowcells_present? do
      validates_with MaximumFlowcellValidator
      validates_with WorkOrderLibraryValidator
    end

    before_destroy :destroy_flowcells_and_update_work_orders

    def experiment_name
      super || id
    end

    def work_orders_include_unsaved
      work_orders.empty? ? flowcells.collect(&:work_order) : work_orders
    end

    def flowcells_present?
      flowcells.present?
    end

    # returns result of sequencing_run
    # returns nil if sequencing_run is pending, 'completed' if completed, 'failed' otherwise
    def result
      return if pending?
      return state if completed?
      'failed'
    end

    # TODO: create(destroy) lab events from one place

    # before destroying sequencing run, it removes work_orders from sequencing state
    # (by removing sequencing lab_events) then destroys flowcells
    def destroy_flowcells_and_update_work_orders
      work_orders.each { |work_order| work_order.aliquot.destroy_sequencing_events }
      flowcells.destroy_all
    end
  end
end
