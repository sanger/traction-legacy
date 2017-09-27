# frozen_string_literal: true

Sequencescape::Api::Base.site = Rails.configuration.sequencescape[:api_base]

if Rails.configuration.sequencescape[:disabled]
  Sequencescape::Api::WorkOrder = Sequencescape::Api::FakeWorkOrder
end
