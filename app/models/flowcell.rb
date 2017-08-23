# frozen_string_literal: true

# Flowcell
class Flowcell < ApplicationRecord
  belongs_to :work_order, inverse_of: :flowcells
  belongs_to :sequencing_run, inverse_of: :flowcells

  delegate :study_uuid, :sample_uuid, to: :work_order
  delegate :library_preparation_type, :data_type, to: :work_order
  delegate :experiment_name, :instrument_name, to: :sequencing_run

  validates_presence_of :flowcell_id, :position

  with_options if: :work_order_present? do
    validates_with MaximumFlowcellValidator
  end

  def work_order_present?
    work_order.present?
  end
end
