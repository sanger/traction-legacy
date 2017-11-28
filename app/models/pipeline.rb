# frozen_string_literal: true

# Pipeline
class Pipeline < ApplicationRecord
  has_many :process_steps
  has_many :requirements

  def requirements_names
    requirements.map(&:name)
  end

  def next_process_step(current_process_step)
    return process_steps.first unless current_process_step.present?
    process_steps[process_steps.index(current_process_step) + 1]
  end
end
