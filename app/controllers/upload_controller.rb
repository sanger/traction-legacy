# frozen_string_literal: true

# upload work orders from Sequencescape
class UploadController < ApplicationController
  #rubocop:disable all
  def create
    sequencescape_work_orders = Sequencescape::Api::WorkOrder.find_by_ids(params['work_orders_ids'])
    factory = Sequencescape::Factory.new(sequencescape_work_orders: sequencescape_work_orders)
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
