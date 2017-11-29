# frozen_string_literal: true

# WorkOrders Controller
class WorkOrdersController < ApplicationController
  attr_reader :work_orders, :work_order, :pipeline

  before_action :set_work_order, only: %i[show]
  before_action :set_pipeline

  def index
    @work_orders = WorkOrder.by_date.includes(:aliquot)
  end

  def show; end

  protected

  def set_work_order
    @work_order ||= current_resource
  end

  def set_pipeline
    @pipeline ||= Pipeline.find(params[:pipeline_id]) if params[:pipeline_id].present?
  end

  def current_resource
    @current_resource = WorkOrder.find(params[:id]) if params[:id].present?
  end

  helper_method :work_orders, :work_order, :pipeline
end
