# frozen_string_literal: true

Sequencescape::Api::Base.site = Rails.configuration.sequencescape_api_base

Sequencescape::Api::WorkOrder = Sequencescape::Api::FakeWorkOrder if Rails.env.test?
