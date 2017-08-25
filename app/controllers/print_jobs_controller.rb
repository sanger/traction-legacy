# frozen_string_literal: true

# prints labels using PMB
class PrintJobsController < ApplicationController
  before_action :check_work_order_ids
  before_action :set_print_job

  attr_reader :print_job

  def create
    print_job.post
    redirect_back fallback_location: root_path, notice: print_job.message
  end

  private

  def check_work_order_ids
    redirect_to root_path, notice: 'Please select some work orders!' if params[:work_order_ids].nil?
  end

  def set_print_job
    @print_job = LabelPrinter::PrintJob.new(
      printer_name: params[:printer_name],
      label_template_id: Rails.configuration.print_my_barcode['label_template_id'],
      work_orders: params[:work_order_ids]
    )
  end
end
