# frozen_string_literal: true

module Sequencescape
  # factory to create traction objects from sequencescape api objects (created with json_client_api)
  class Factory
    include ActiveModel::Model

    attr_reader :sequencescape_work_orders, :pipeline

    def self.create!(sequencescape_work_orders)
      new(sequencescape_work_orders).create!
    end

    def initialize(sequencescape_work_orders)
      @sequencescape_work_orders = sequencescape_work_orders
      @pipeline = Pipeline.find_by(name: sequencescape_work_orders.first.order_type)
    end

    def create!
      sequencescape_work_orders.each do |sequencescape_work_order|
        ActiveRecord::Base.transaction do
          aliquot = Aliquot.new(name: sequencescape_work_order.name)
          create_work_order(sequencescape_work_order, aliquot)
          receptacle = Receptacle.new
          LabEvent.create!(aliquot: aliquot,
                           receptacle: receptacle,
                           date: DateTime.now,
                           state: 'transferred')
          LabEvent.create!(aliquot: aliquot,
                           receptacle: receptacle,
                           date: DateTime.now,
                           state: 'process_started',
                           process_step: pipeline.next_process_step)
        end
      end
    end

    def build_work_order_requirements(work_order)
      [].tap do |attributes_list|
        pipeline.requirements.each do |requirement|
          attributes_list << { requirement_id: requirement.id, value: work_order.send(requirement.name) }
        end
      end
    end

    def create_work_order(work_order, aliquot)
      WorkOrder.create!(aliquot: aliquot,
                        sequencescape_id: work_order.id,
                        work_order_requirements_attributes: build_work_order_requirements(work_order),
                        sample_uuid: work_order.sample_uuid,
                        study_uuid: work_order.study_uuid)
    end
  end
end
