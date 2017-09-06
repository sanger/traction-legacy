# frozen_string_literal: true

Sequencescape::Api::Base.site = Rails.configuration.sequencescape_api_base

if Rails.configuration.sequencescape_disabled
  Sequencescape::Api::WorkOrder = Sequencescape::Api::FakeWorkOrder
end
