# frozen_string_literal: true

# reception for work orders from sqsc
class ReceptionsController < ApplicationController
  def index
    @work_orders = Sqsc::Api::WorkOrder.for_reception
  end
end
