# frozen_string_literal: true

# upload work orders from Sequencescape
class UploadController < ApplicationController
  #rubocop:disable all
  def create
    work_orders = Sequencescape::Api::WorkOrder.find_by_ids(params['work_orders_ids'])
    factory = Sequencescape::Factory.new(sequencescape_work_orders: work_orders,
                                          sequencescape_work_orders_ids: params['work_orders_ids'])
    if factory.valid?
      if factory.create!
        redirect_to work_orders_path, notice: 'Work orders were successfully uploaded'
      else
        redirect_to reception_path, error: 'Something went wrong...'
      end
    else
      flash[:error] = factory.errors.full_messages.join('. ')
      redirect_to reception_path
    end
  end
  #rubocop:enable all
end
