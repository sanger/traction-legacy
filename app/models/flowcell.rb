# frozen_string_literal: true

# Flowcell
class Flowcell < ApplicationRecord
  belongs_to :work_order
  belongs_to :sequencing_run

  validates_presence_of :flowcell_id, :position
end
