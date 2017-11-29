# frozen_string_literal: true

# reception for work orders from Sequencescape
class ReceptionController < ApplicationController
  attr_reader :pipeline
  before_action :set_pipeline

  def index
    @work_orders = Sequencescape::Api::WorkOrder.for_reception
  end

  # rubocop:disable Metrics/AbcSize
  def upload
    if params['work_orders_ids'].nil?
      redirect_to pipeline_reception_path(pipeline)
    else
      Sequencescape::Factory.create!(
        Sequencescape::Api::WorkOrder.find_by_ids(params['work_orders_ids'])
      )
      redirect_to pipeline_work_orders_path(pipeline),
                  notice: "#{params['work_orders_ids'].length}
                  Work orders were successfully uploaded"
    end
  end
  # rubocop:enable Metrics/AbcSize

  def set_pipeline
    @pipeline ||= Pipeline.find(params[:pipeline_id]) if params[:pipeline_id].present?
  end

  helper_method :pipeline
end
