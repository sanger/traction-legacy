# frozen_string_literal: true

module Gridion
  # SequencingRun
  class SequencingRun < ApplicationRecord
    has_many :flowcells, inverse_of: :sequencing_run,
                         dependent: :destroy,
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

    def experiment_name
      super || id
    end

    def work_orders_include_unsaved
      work_orders.empty? ? flowcells.collect(&:work_order) : work_orders
    end

    def flowcells_present?
      flowcells.present?
    end

    def result
      return if pending?
      return state if completed?
      'failed'
    end
  end
end
