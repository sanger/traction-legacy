# frozen_string_literal: true

# PipelinesController
class PipelinesController < ApplicationController
  attr_reader :pipelines

  def index
    @pipelines = Pipeline.all
    render layout: false
  end

  helper_method :pipelines
end
