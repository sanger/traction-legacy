module Workflow
  class WorkOrder
    include ActiveModel::Model
    include AASM

    attr_accessor :state

    aasm do
      state :started, initial: true
      state :qc
      state :library_preparation
      state :sequencing
      state :completed

      before_all_events :set_current_state
      after_all_events :set_state

      event :qc do
        transitions from: :started, to: :qc
      end

      event :library_preparation do
        transitions from: :qc, to: :library_preparation
      end

      event :sequencing do
        transitions from: :library_preparation, to: :sequencing
      end

      event :completed do
        transitions from: :sequencing, to: :completed
      end

    end

    def initialize(attributes = {})
      super
      initialize_state
    end

    private

    def set_current_state
      aasm.current_state = state.to_sym
    end

    def set_state
      self.state = aasm.current_state
    end

    def initialize_state
      self.state ||= aasm.current_state
    end

  end
end