# frozen_string_literal: true

# A Sample
class Sample < ApplicationRecord
  enum qc_state: %i[fail proceed_at_risk proceed]

  belongs_to :tube, optional: true
  validates :name, presence: true, uniqueness: true
end
