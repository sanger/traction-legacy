module Workflow

  class Step

    include ActiveModel::Model

    attr_accessor :name, :heading, :previous_step, :next_step, :state

    validates_presence_of :name

    def initialize(attributes = {})
      super
    end

    def heading
      @heading ||= name.to_s.humanize
    end

    def state
      @state ||= name
    end

    def first?
      previous_step.nil?
    end

    def last?
      next_step.nil?
    end

  end
end