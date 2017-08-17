# frozen_string_literal: true

# LibraryPerparationsController
class LibraryPreparationsController < ApplicationController
  attr_reader :work_order, :work_orders

  def index
    @work_orders = WorkOrder.qc
  end

  def edit
    @work_order = WorkOrderForm::LibraryPreparation.new(current_resource)
  end

  def update
    @work_order = WorkOrderForm::LibraryPreparation.new(current_resource)
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
      library_attributes: %i[volume kit_number ligase_batch_number]
    )
  end
end
