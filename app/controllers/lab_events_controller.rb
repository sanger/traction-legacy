# frozen_string_literal: true

# LabProcessesController
class LabEventsController < ApplicationController
  def new
    @lab_event = LabEvent.new
    @process_step = pipeline.find_process_step(params[:process_step_name])
    @work_order = work_order
  end

  def create
    @lab_event = LabEvent.new(lab_event_params.merge(date: DateTime.now))
    if @lab_event.valid?
      @lab_event.save
      redirect_to pipeline_work_orders_path(pipeline),
                  notice: 'Lab event was successfully recorded'
    else
      render :new
    end
  end

  def lab_event_params
    metadata_items_attributes = params.require(:metadata_items_attributes).try(:permit!)
    params.permit(:work_order_id, :process_step_id)
          .merge(metadata_items_attributes: metadata_items_attributes)
  end

  def work_order
    @work_order ||= WorkOrder.find(params[:work_order_id])
  end
end
