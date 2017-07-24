# frozen_string_literal: true

# Samples Controller
class SamplesController < ApplicationController
  attr_reader :samples

  def index

    @samples = Sample.all

  end

  helper_method :samples

end
