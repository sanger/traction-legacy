# frozen_string_literal: true

# TubeBuilder
module TubeBuilder
  extend ActiveSupport::Concern

  included do
    after_initialize :build_tube
  end

  private

  def build_tube
    self.tube = Tube.new
  end
end
