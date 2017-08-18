# frozen_string_literal: true

# QcsController
class QcsController < ApplicationController
  attr_reader :work_order, :work_orders

  def index
    @work_orders = WorkOrder.started
  end

  def edit
    @work_order = WorkOrderForm::Qc.new(current_resource)
  end

  def update
    @work_order = WorkOrderForm::Qc.new(current_resource)
    if work_order.submit(work_order_params)
      redirect_to work_order_path(work_order), notice: 'Work Order successfully updated'
    else
      render :edit
    end
  end

  def current_resource
    @current_resource = WorkOrder.find(params[:id]) if params[:id].present?
  end

  protected

  helper_method :work_order, :work_orders

  def work_order_params
    params.require(:work_order).permit(
      aliquot_attributes: %i[id concentration fragment_size qc_state]
    )
  end
end
