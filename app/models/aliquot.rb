# frozen_string_literal: true

# Aliquot
class Aliquot < ApplicationRecord
  belongs_to :tube
  has_one :work_order

  enum qc_state: %i[fail proceed_at_risk proceed]

  validates_presence_of :name

  include TubeBuilder
end
