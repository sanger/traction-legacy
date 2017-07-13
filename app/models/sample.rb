# frozen_string_literal: true

# A Sample
class Sample < ApplicationRecord
  enum qc_state: %i[fail proceed_at_risk proceed]

  validates :name, presence: true, uniqueness: true
end
