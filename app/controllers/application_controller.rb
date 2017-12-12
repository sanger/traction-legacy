# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  attr_reader :pipeline
  before_action :set_pipeline

  # Ensure that the exception notifier is working. It will send an email to the standard email address.
  def test_exception_notifier
    raise 'This is a test. This is only a test.'
  end

  def set_pipeline
    @pipeline ||= Pipeline.find_by_name(params[:pipeline_name]) if params[:pipeline_name].present?
  end

  helper_method :pipeline
end
