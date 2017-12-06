# frozen_string_literal: true

# Flowcell
class Flowcell < ApplicationRecord
  belongs_to :work_order, inverse_of: :flowcells, touch: true
  belongs_to :sequencing_run, class_name: 'Gridion::SequencingRun',
                              inverse_of: :flowcells,
                              foreign_key: :gridion_sequencing_run_id

  delegate :study_uuid, :sample_uuid, to: :work_order
  delegate :library_preparation_type, :data_type, to: 'work_order.details'
  delegate :experiment_name, :instrument_name, to: :sequencing_run

  validates_presence_of :flowcell_id, :position

  def work_order_present?
    work_order.present?
  end
end
