# frozen_string_literal: true

# upload work orders from sqsc
class UploadController < ApplicationController
  def create
    sqsc_work_orders = Sqsc::Api::WorkOrder.find_by_ids(params['work_orders_ids'])
    Sqsc::Factory.new(sqsc_work_orders: sqsc_work_orders).create!
    redirect_to work_orders_path
  end
end
