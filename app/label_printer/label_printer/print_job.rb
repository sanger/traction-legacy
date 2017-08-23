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
      @label_template_id = find_label_template_id
    end

    def execute
      LabelPrinter::PrintMyBarcodeApi::PrintJob.create(attributes) if valid?
    rescue JsonApiClient::Errors::ConnectionError
      errors.add(:printmybarcode, 'is down')
      false
    end

    private

    def attributes
      { printer_name: printer_name,
        label_template_id: label_template_id,
        labels: labels }
    end

    def find_label_template_id
      label_template = find_label_template(tube_label_template_name)
      label_template.id if label_template.present?
    end

    def tube_label_template_name
      'traction_tube_label_template'
    end

    def find_label_template(_label_template_name)
      LabelPrinter::PrintMyBarcodeApi::LabelTemplate.where(name: tube_label_template_name).first
    rescue JsonApiClient::Errors::ConnectionError
      errors.add(:printmybarcode, 'is down')
      nil
    end
  end
end
