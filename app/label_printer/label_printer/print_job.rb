# frozen_string_literal: true

module LabelPrinter
  # generates print job and sends it to Print my barcode
  class PrintJob
    include ActiveModel::Model
    attr_accessor :aliquots, :printer_name, :labels, :label_template_id

    validates :printer_name, :label_template_id, :aliquots, presence: true

    def initialize(attributes = {})
      super
      @labels = TubeLabelFactory.generate_labels(aliquots)
    end

    def execute
      PMB::PrintJob.execute(attributes) if valid?
    rescue JsonApiClient::Errors::ServerError, JsonApiClient::Errors::UnexpectedStatus => e
      errors.add(:printmybarcode, 'is down')
      false
    end

    private

    def attributes
      { printer_name: printer_name,
        label_template_id: label_template_id,
        labels: labels }
    end

  end
end
