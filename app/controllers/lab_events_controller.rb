# frozen_string_literal: true

# LabProcessesController
class LabEventsController < ApplicationController
  def new
    @lab_event = LabEvent.new
    @process_step = pipeline.find_process_step(params[:process_step_name])
    @work_order = work_order
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
      render :new, pipeline: pipeline, work_order: work_order
    end
  end
  # rubocop:enable Metrics/AbcSize

  def edit
    @lab_event = LabEvent.find(params[:id])
    @process_step = @lab_event.process_step
    @work_order = work_order
  end

  # rubocop:disable Metrics/AbcSize
  def update
    @lab_event = LabEvent.find(params[:id])
    @process_step = @lab_event.process_step
    @lab_event.assign_attributes(metadata_items_attributes: lab_event_params[:metadata_items_attributes])
    if @lab_event.valid?
      @lab_event.save
      redirect_to pipeline_work_order_path(pipeline, work_order),
                  notice: "#{@lab_event.name} step was successfully edited"
    else
      render :edit, pipeline: pipeline, work_order: work_order, lab_event: @lab_event
    end
  end
  # rubocop:enable Metrics/AbcSize

  def lab_event_params
    metadata_items_attributes = params.require(:metadata_items_attributes).try(:permit!)
    params.permit(:work_order_id, :process_step_id)
          .merge(metadata_items_attributes: metadata_items_attributes)
  end

  def work_order
    @work_order ||= WorkOrder.find(params[:work_order_id])
  end
end
