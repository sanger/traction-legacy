# frozen_string_literal: true

# Library
class Library < ApplicationRecord
  belongs_to :work_order
  belongs_to :tube

  validates_presence_of :kit_number, :volume

  include TubeBuilder
end
