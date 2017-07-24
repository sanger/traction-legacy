# frozen_string_literal: true

# A tube
class Tube < ApplicationRecord

  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "TRAC-#{self.id}")
  end
end
