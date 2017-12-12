# frozen_string_literal: true

# A step within pipeline
class ProcessStep < ApplicationRecord
  belongs_to :pipeline
  has_many :lab_events
  has_many :metadata_fields

  def find_metadata_field(name)
    metadata_fields.detect { |field| field.name == name.to_s }
  end
end
