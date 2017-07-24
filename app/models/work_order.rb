class WorkOrder < ApplicationRecord

  belongs_to :aliquot

  enum state: %i[started qc library_preparation sequencing completed]

  attr_readonly :uuid

  validates_presence_of :uuid

  accepts_nested_attributes_for :aliquot
end
