# frozen_string_literal: true

# reception for work orders from Sequencescape
class ReceptionController < ApplicationController
  def index
    @work_orders = Sequencescape::Api::WorkOrder.for_reception
  end

  def upload
    if params['work_orders_ids'].nil?
      redirect_to reception_path
    else
      Sequencescape::Factory.create!(
        Sequencescape::Api::WorkOrder.find_by_ids(params['work_orders_ids'])
      )
      redirect_to work_orders_path,
                  notice: "#{params['work_orders_ids'].length}
                  Work orders were successfully uploaded"
    end
  end
end
