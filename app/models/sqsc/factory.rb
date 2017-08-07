# frozen_string_literal: true

module Sqsc
  # factory to create traction objects from sqsc api objects (created using json_client_api)
  class Factory
    include ActiveModel::Model

    attr_accessor :sqsc_work_orders

    def create!
      sqsc_work_orders.each do |sqsc_work_order|
        tube = Tube.create!
        sample = Sample.create!(name: sqsc_work_order.name, uuid: sqsc_work_order.sample_uuid)
        aliquot = Aliquot.create!(tube: tube, sample: sample)
        work_order = WorkOrder.create!(aliquot: aliquot, uuid: sqsc_work_order.id)
        sqsc_work_order.update_state_to(work_order.state)
      end
    end
  end
end
