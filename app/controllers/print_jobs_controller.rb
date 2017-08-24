# frozen_string_literal: true

# prints labels using PMB
class PrintJobsController < ApplicationController
  def create
    if params[:work_order_ids].nil?
      redirect_to root_path, notice: "Please select some work orders!"
    else
      print_job = LabelPrinter::PrintJob.new(printer_name: params[:printer_name], label_template_id: Rails.configuration.print_my_barcode["label_template_id"], work_orders: params[:work_order_ids])
      print_job.post
      redirect_back fallback_location: root_path, notice: print_job.message
    end
  end

end
