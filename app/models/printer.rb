# frozen_string_literal: true

# Printer
class Printer < ApplicationRecord
  validates_presence_of :name

  def self.names
    pluck(:name)
  end
end
