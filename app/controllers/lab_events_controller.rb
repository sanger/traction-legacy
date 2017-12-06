# frozen_string_literal: true

# LabEventsController
class LabEventsController < ApplicationController
  before_action :set_lab_event, only: %i[show edit update]
  before_action :set_work_order

  def new
    @lab_event = LabEvent.new
    @process_step = pipeline.find_process_step(params[:process_step_name])
  end

  # rubocop:disable Metrics/AbcSize
  def create
    @lab_event = LabEvent.new(lab_event_params.merge(date: DateTime.now))
    @process_step = ProcessStep.find(params[:process_step_id])
    if @lab_event.valid?
      @lab_event.save
      redirect_to pipeline_work_orders_path(pipeline),
                  notice: "#{@lab_event.name} step was successfully recorded"
    else
      render :new, pipeline: pipeline, work_order: @work_order
    end
  end
  # rubocop:enable Metrics/AbcSize

  def show
    redirect_to edit_pipeline_work_order_lab_event_path(pipeline, @work_order, @lab_event)
  end

  def edit
    @process_step = @lab_event.process_step
  end

  def update
    @process_step = @lab_event.process_step
    @lab_event.assign_attributes(metadata_items_attributes: lab_event_params[:metadata_items_attributes])
    if @lab_event.valid?
      @lab_event.save
      redirect_to pipeline_work_order_path(pipeline, @work_order),
                  notice: "#{@lab_event.name} step was successfully edited"
    else
      render :edit, pipeline: pipeline, work_order: @work_order, lab_event: @lab_event
    end
  end

  private

  def lab_event_params
    metadata_items_attributes = params.require(:metadata_items_attributes).try(:permit!)
    params.permit(:work_order_id, :process_step_id)
          .merge(metadata_items_attributes: metadata_items_attributes)
  end

  def set_work_order
    @work_order ||= WorkOrder.find(params[:work_order_id])
  end

  def set_lab_event
    @lab_event ||= LabEvent.find(params[:id])
  end
end
