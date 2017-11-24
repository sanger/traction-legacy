# frozen_string_literal: true

# Metadata 'key'
class MetadataField < ApplicationRecord
  belongs_to :process_step
  has_many :options
end
