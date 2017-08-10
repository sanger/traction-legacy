# frozen_string_literal: true

# reception for work orders from Sequencescape
class ReceptionController < ApplicationController
  def index
    @work_orders = Sequencescape::Api::WorkOrder.for_reception
  end
end
