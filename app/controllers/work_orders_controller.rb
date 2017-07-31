# frozen_string_literal: true

# WorkOrders Controller
class WorkOrdersController < ApplicationController
  attr_reader :work_orders, :work_order

  before_action :set_work_order, only: %i[show]

  def index
    @work_orders = WorkOrder.all
  end

  def show; end

  def edit
    @work_order = WorkOrderForm.new(current_resource)
  end

  def update
    @work_order = WorkOrderForm.new(current_resource)
    if work_order.submit(params[:work_order])
      redirect_to work_order_path(work_order), notice: 'Work Order successfully updated'
    else
      render :edit
    end
  end

  protected

  def set_work_order
    @work_order ||= current_resource
  end

  def current_resource
    @current_resource = WorkOrder.find(params[:id]) if params[:id].present?
  end

  helper_method :work_orders, :work_order
end
