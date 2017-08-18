# frozen_string_literal: true

# Flowcell
class Flowcell < ApplicationRecord
  belongs_to :work_order
  belongs_to :sequencing_run

  delegate :study_uuid, :sample_uuid, to: :work_order
  delegate :library_preparation_type, :data_type, to: :work_order
  delegate :experiment_name, :instrument_name, to: :sequencing_run

  validates_presence_of :flowcell_id, :position
end
