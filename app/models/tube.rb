# frozen_string_literal: true

# A tube
class Tube < ApplicationRecord
  has_one :sample
end
