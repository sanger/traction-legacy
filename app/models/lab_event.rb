# frozen_string_literal: true

# Lab Event - anything that happens with aliquot in a lab
class LabEvent < ApplicationRecord
  belongs_to :receptacle
  belongs_to :aliquot
  belongs_to :process_step, optional: true
  has_many :metadata_items

  enum action: %i[aliquot_transferred process_started process_ended stored]

  def metadata
    @metadata ||= (metadata_items.includes(:metadata_field).collect(&:to_h).inject(:merge!) || {})
  end
end
