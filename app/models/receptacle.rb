# frozen_string_literal: true

# A Receptacle
class Receptacle < ApplicationRecord
  has_many :lab_events

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "TRAC-#{id}")
  end
end
