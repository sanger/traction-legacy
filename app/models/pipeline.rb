# frozen_string_literal: true

# Pipeline
class Pipeline < ApplicationRecord
  has_many :process_steps
end
