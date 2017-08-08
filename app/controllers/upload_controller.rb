# frozen_string_literal: true

# upload work orders from sqsc
class UploadController < ApplicationController
  #rubocop:disable all
  def create
    sqsc_work_orders = Sqsc::Api::WorkOrder.find_by_ids(params['work_orders_ids'])
    factory = Sqsc::Factory.new(sqsc_work_orders: sqsc_work_orders)
    if factory.valid?
      if factory.create!
        flash[:notice] = 'Work orders were successfully uploaded'
        redirect_to work_orders_path
      else
        flash[:error] = 'Something went wrong...'
        redirect_back fallback_location: root_path
      end
    else
      flash[:error] = factory.errors.full_messages.join(', ')
      redirect_back fallback_location: root_path
    end
  end
  #rubocop:enable all
end
