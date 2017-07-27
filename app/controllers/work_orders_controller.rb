# frozen_string_literal: true

# WorkOrders Controller
class WorkOrdersController < ApplicationController
  attr_reader :work_orders, :work_order

  before_action :set_work_order, only: %i[edit show]

  def index
    @work_orders = WorkOrder.all
  end

  def show; end

  def edit; end

  def update
    @work_order = current_resource
    if work_order.update_attributes(work_order_params)
      work_order.next_state!
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

  def work_order_params
    params.require(:work_order)
          .permit(
            aliquot_attributes: %i[id concentration fragment_size qc_state],
            library_attributes: %i[volume kit_number ligase_batch_number]
          )
  end

  helper_method :work_orders, :work_order
end
