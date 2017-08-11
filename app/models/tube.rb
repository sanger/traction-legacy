# frozen_string_literal: true

# A Tube
class Tube < ApplicationRecord
  after_create :generate_barcode

  private

  def generate_barcode
    update_column(:barcode, "TRAC-#{id}")
  end
end
