# frozen_string_literal: true

# A step within pipeline
class ProcessStep < ApplicationRecord
  belongs_to :pipeline
  has_many :lab_events
  has_many :matadata_fields
end
