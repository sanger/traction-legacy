# frozen_string_literal: true

# Pipeline
class Pipeline < ApplicationRecord
  has_many :process_steps
  has_many :requirements

  def requirements_names
    requirements.map(&:name)
  end

  def next_process_step(current_process_step = nil)
    return process_steps.detect { |step| step.position == 1 } unless current_process_step.present?
    process_steps.detect { |step| step.position == (current_process_step.position + 1) }
  end

  def find_process_step(process_step_name)
    process_steps.find_by(name: process_step_name)
  end

  def to_param
    name
  end
end
