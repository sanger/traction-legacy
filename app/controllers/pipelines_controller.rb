# frozen_string_literal: true

# PipelinesController
class PipelinesController < ApplicationController
  attr_reader :pipeline, :pipelines
  before_action :set_pipeline

  def index
    @pipelines = Pipeline.all
  end

  def set_pipeline
    @pipeline ||= Pipeline.first
  end

  helper_method :pipeline, :pipelines
end
