# frozen_string_literal: true

# Metadata 'value'
class MetadataItem < ApplicationRecord
  belongs_to :metadata_field
  belongs_to :lab_event

  def to_h
    { metadata_field.name => value }
  end
end
