# frozen_string_literal: true

# Metadata 'key', indicates what metadata should be collected during particular process_step
# different process_steps have different metadata fields
class MetadataField < ApplicationRecord
  belongs_to :process_step
  has_many :options
end
