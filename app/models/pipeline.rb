# frozen_string_literal: true

# Pipeline
class Pipeline < ApplicationRecord
  has_many :process_steps
  has_many :requirements

  def requirements_names
    requirements.map(&:name)
  end

  def next_process(current_process)
    return process_steps.first unless current_process.present?
    process_steps[process_steps.index(current_process) + 1]
  end
end
