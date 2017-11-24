# frozen_string_literal: true

# Pipeline
class Pipeline < ApplicationRecord
  has_many :process_steps
  has_many :requirements

  def requirements_names
    requirements.map(&:name)
  end
end
