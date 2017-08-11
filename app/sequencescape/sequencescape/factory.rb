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
          sample = Sample.find_or_create_by!(uuid: sequencescape_work_order.sample_uuid)
          aliquot = Aliquot.new(sample: sample, name: sequencescape_work_order.name)
          work_order = create_work_order(sequencescape_work_order, aliquot)
          Sequencescape::Api::WorkOrder.update_state(work_order)
        end
      end
    end

    def create_work_order(work_order, aliquot)
      WorkOrder.create!(aliquot: aliquot,
                        sequencescape_id: work_order.id,
                        library_preparation_type: work_order.library_preparation_type,
                        file_type: work_order.file_type,
                        number_of_flowcells: work_order.number_of_flowcells)
    end
  end
end
