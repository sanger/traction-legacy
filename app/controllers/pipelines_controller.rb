# frozen_string_literal: true

# PipelinesController
class PipelinesController < ApplicationController
  attr_reader :pipelines

  def index
    redirect_to pipeline_work_orders_path(Pipeline.first)
    # @pipelines = Pipeline.all
    # render layout: false
  end

  helper_method :pipelines
end
