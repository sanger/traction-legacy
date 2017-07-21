# frozen_string_literal: true

# A tube
class Tube < ApplicationRecord
  has_one :sample

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "TRAC-#{self.id}")
  end
end
