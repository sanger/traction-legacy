# frozen_string_literal: true

# prints labels using PMB
class PrintJobsController < ApplicationController
  def create
    aliquots = Aliquot.find_by_work_orders_ids(params[:work_orders_ids])
    print_job = LabelPrinter::PrintJob.new(printer_name: params[:printer_name], label_template_id: Rails.configuration.print_my_barcode["label_template_id"], aliquots: aliquots)
    if print_job.execute
      flash[:notice] = "Your label(s) have been sent to printer #{print_job.printer_name}"
    else
      flash[:error] = print_job.errors.full_messages.join(', ')
    end
    redirect_back fallback_location: root_path
  end

end
