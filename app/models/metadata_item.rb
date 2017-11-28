# frozen_string_literal: true

# Metadata 'value'
class MetadataItem < ApplicationRecord
  belongs_to :metadata_field
  belongs_to :lab_event

  scope :with_metadata_fields, (-> { includes(:metadata_field) })

  def to_h
    { metadata_field.name => value }
  end
end
