# frozen_string_literal: true

Sqsc::Api::Base.site = Rails.configuration.sqsc_api_base

Sqsc::Api::WorkOrder = Sqsc::Api::FakeWorkOrder if Rails.env.test?
