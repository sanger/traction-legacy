# frozen_string_literal: true

# Metadata 'value'
class MetadataItem < ApplicationRecord
  belongs_to :metadata_field
  belongs_to :lab_event

  validates :value,
            presence: { message: lambda do |object, _data|
                                   "#{object.key} can not be empty"
                                 end },
            if: :metadata_field_required?

  scope :with_metadata_fields, (-> { includes(:metadata_field) })

  def to_h
    { key => value }
  end

  def metadata_field_required?
    metadata_field.required
  end

  def key
    metadata_field.name
  end
end
