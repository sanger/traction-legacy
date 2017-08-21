# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelPrinter::PrintJob, type: :model do
  it 'has printer_name' do
    print_job = LabelPrinter::PrintJob.new(printer_name: 'name')
    expect(print_job.printer_name).to eq 'name'
  end

  it 'finds tube label template id' do
    print_job = LabelPrinter::PrintJob.new
    LabelTemplate = Struct.new(:id)
    label_template = LabelTemplate.new("1")
    allow(print_job).to receive(:find_label_template)
                    .with('traction_tube_label_template') { label_template }
    expect(print_job.tube_label_template_id).to eq "1"
  end

  it 'has correct labels' do
    aliquots = create_list(:aliquot, 2)
    print_job = LabelPrinter::PrintJob.new(printer_name: 'name', aliquots: aliquots)
    labels =  {body:
                [
                  {main_label:
                    {top_line: aliquots[0].source_plate_barcode,
                      middle_line: aliquots[0].source_well_position,
                      bottom_line: "",
                      round_label_top_line: "",
                      round_label_bottom_line: "",
                      barcode: aliquots[0].tube_barcode}
                  },
                  {main_label:
                    {top_line: aliquots[1].source_plate_barcode,
                      middle_line: aliquots[1].source_well_position,
                      bottom_line: "",
                      round_label_top_line: "",
                      round_label_bottom_line: "",
                      barcode: aliquots[1].tube_barcode}
                  }
                ]
              }
    expect(print_job.labels).to eq labels
  end
end
