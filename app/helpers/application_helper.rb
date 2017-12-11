# frozen_string_literal: true

module ApplicationHelper

  def current_year
    @current_year ||= Date.today.year
  end

  # returns link to the next lab_event
  # or link to sequencing_run if the next lab_event is 'sequencing'
  def link_to_next_lab_event_creation(pipeline, work_order)
    next_state = work_order.aliquot_next_state
    return new_pipeline_work_order_lab_event_path(pipeline, work_order,
      process_step_name: next_state) unless next_state =='sequencing'
    return pipeline_sequencing_runs_path(pipeline)
  end
end
