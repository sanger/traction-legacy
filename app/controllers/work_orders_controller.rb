# frozen_string_literal: true

# WorkOrders Controller
class WorkOrdersController < ApplicationController
  attr_reader :work_orders, :work_order

  before_action :set_work_order, only: %i[show]

  def index
    @work_orders = WorkOrder.by_date
                            .includes(aliquot: {lab_events: {process_step: :pipeline }})
                            .by_aliquot_next_state(params[:process_step_name])
  end

  def show; end

  protected

  def set_work_order
    @work_order ||= current_resource
  end

  def current_resource
    @current_resource = WorkOrder.find(params[:id]) if params[:id].present?
  end

  helper_method :work_orders, :work_order
end
