# frozen_string_literal: true

module WorkOrderForm
  # Base class for WorkOrderForm
  class Base
    include ActiveModel::Model

    attr_reader :work_order

    delegate_missing_to :work_order

    def self.model_name
      ActiveModel::Name.new(WorkOrder)
    end

    def initialize(work_order)
      @work_order = work_order
    end

    def persisted?
      work_order.id?
    end

    def submit(params)
      work_order.assign_attributes(params)
      if valid?
        update_work_order
        true
      else
        false
      end
    end

    def update_work_order
      ActiveRecord::Base.transaction do
        update_state
        work_order.save
        update_sequencescape_state
      end
    end

    def update_state; end

    def update_sequencescape_state
      Sequencescape::Api::WorkOrder.update_state(work_order)
    end
  end
end
