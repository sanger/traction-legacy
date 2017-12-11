# frozen_string_literal: true

# Aliquot
# aliquot is a 'liquid' to be sequenced
# it goes through various lab_events up to sequencing
class Aliquot < ApplicationRecord
  has_one :work_order
  has_many :lab_events
  belongs_to :parent, class_name: 'Aliquot', optional: true

  validates_presence_of :name

  def source_plate_barcode
    name.split(':').first
  end

  def source_well_position
    name.split(':').last
  end

  def short_source_plate_barcode
    source_plate_barcode.split(//).last(4).join
  end

  # returns current process_step (collects all process_steps and returns the last one)
  def current_process_step
    lab_events.collect { |lab_event| lab_event.process_step if lab_event.process_step.present? }.compact.last
  end

  # returns current process step name, which is also an aliquot current state
  def current_process_step_name
    current_process_step.try(:name)
  end
  alias state current_process_step_name

  # returns the last lab_event with process step
  def last_lab_event_with_process_step
    lab_events.collect { |lab_event| lab_event if lab_event.process_step.present? }.compact.last
  end

  # returns state of the last lab event (i.e. 'process_started', 'completed', etc.)
  def action
    last_lab_event_with_process_step.state
  end

  # returns next process_step name, which is also an aliquot next state
  def next_process_step_name
    pipeline.next_process_step(current_process_step).try(:name)
  end
  alias next_state next_process_step_name

  # TODO: connect work_order or aliquot with pipeline?
  def pipeline
    current_process_step.pipeline
  end

  # checks if aliquot has a lab_event with particular process step
  def lab_event?(step_name)
    lab_events.where(process_step: ProcessStep.where(name: step_name, pipeline: pipeline).first).present?
  end

  def receptacle
    lab_events.last.receptacle
  end

  def receptacle_barcode
    receptacle.barcode
  end

  # TODO: create(destroy) lab events from one place

  def create_sequencing_event(lab_event_state)
    lab_events.create!(date: DateTime.now,
                       state: lab_event_state || 'process_started',
                       receptacle: receptacle,
                       process_step: pipeline.find_process_step(:sequencing))
  end

  def destroy_sequencing_events
    sequencing_events = lab_events.where(process_step: pipeline.find_process_step(:sequencing))
    lab_events.destroy(sequencing_events)
    last_lab_event_with_process_step.update_sequencescape
  end
end
