# frozen_string_literal: true

module LabelPrinter
  # generates print job and sends it to Print my barcode
  class PrintJob
    include ActiveModel::Model

    attr_accessor :printer_name, :label_template_id, :work_orders

    attr_reader :labels

    def initialize(attributes = {})
      super
      @labels = Labels.new(work_orders)
    end

    def work_orders=(work_orders)
      @work_orders = WorkOrder.includes(:aliquot).find(work_orders)
    end

    def message
      response_ok? ? I18n.t('printing.success') : I18n.t('printing.failure')
    end

    def post
      PMB::PrintJob.execute(attributes)
      @response_ok = true
    rescue JsonApiClient::Errors::ServerError, JsonApiClient::Errors::UnexpectedStatus
      @response_ok = false
    end

    def response_ok?
      @response_ok ||= false
    end

    private

    def attributes
      { printer_name: printer_name,
        label_template_id: label_template_id,
        labels: labels.to_h }
    end
  end
end
