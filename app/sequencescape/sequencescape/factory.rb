# frozen_string_literal: true

module Sequencescape
  # factory to create traction objects from sequencescape api objects (created with json_client_api)
  class Factory
    include ActiveModel::Model

    attr_reader :sequencescape_work_orders

    def self.create!(sequencescape_work_orders)
      new(sequencescape_work_orders).create!
    end

    def initialize(sequencescape_work_orders)
      @sequencescape_work_orders = sequencescape_work_orders
    end

    def create!
      sequencescape_work_orders.each do |sequencescape_work_order|
        ActiveRecord::Base.transaction do
          aliquot = Aliquot.new(name: sequencescape_work_order.name)
          work_order = create_work_order(sequencescape_work_order, aliquot)
          Sequencescape::Api::WorkOrder.update_state(work_order)
        end
      end
    end

    def create_work_order(work_order, aliquot)
      WorkOrder.create!(aliquot: aliquot,
                        sequencescape_id: work_order.id,
                        library_preparation_type: work_order.library_preparation_type,
                        data_type: work_order.data_type,
                        number_of_flowcells: work_order.number_of_flowcells,
                        sample_uuid: work_order.sample_uuid,
                        study_uuid: work_order.study_uuid)
    end
  end
end
