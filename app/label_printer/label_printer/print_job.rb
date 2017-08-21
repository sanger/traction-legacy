# frozen_string_literal: true

module LabelPrinter
  # generates print job and sends it to Print my barcode
  class PrintJob
    include ActiveModel::Model
    attr_accessor :aliquots, :printer_name, :labels, :tube_label_template_id

    def labels
      @labels ||= TubeLabelFactory.generate_labels(aliquots)
    end

    def tube_label_template_id
      @tube_label_template_id ||= find_label_template(tube_label_template_name).id
    end

    def tube_label_template_name
      'traction_tube_label_template'
    end

    def attributes
      { printer_name: printer_name,
        label_template_id: tube_label_template_id,
        labels: labels }
    end

    def find_label_template(label_template_name)
      PMB::LabelTemplate.where(name: tube_label_template_name).first
    end

    def execute
      PMB::PrintJob.create(attributes)
    end
  end
end
