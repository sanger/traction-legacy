# frozen_string_literal: true

module WebmockHelpers
  def stub(thing)
    stub_request(:get, url(thing))
      .with(headers: headers)
      .to_return(status: status, body: response_body(thing), headers: headers)
  end

  def url(thing)
    Addressable::Template.new(Rails.configuration.sequencescape_api_base + find_url(thing))
  end

  def response_body(thing)
    File.read(File.join('spec', 'data', 'sequencescape', "#{thing}.json"))
    # File.open(Rails.root.join("spec/support/jsons_for_webmock/#{thing}.txt"), 'r', &:read)
  end

  def find_url(thing)
    reception_filter = 'filter[order_type]=traction_grid_ion&filter[state]=pending'
    { reception: "/work_orders?#{reception_filter}&include=samples,source_receptacle,study",
      successful_upload: '/work_orders?filter[id]=6,7&include=samples,source_receptacle,study',
      find_by_id: '/work_orders?filter[id]={id}' }[thing]
  end

  def stub_updates
    stub :find_by_id
    stub_request(:patch, //)
      .with(headers: headers)
      .to_return(status: status, headers: headers)
  end

  def status
    200
  end

  def headers
    { 'Accept' => 'application/vnd.api+json',
      'Content-Type' => 'application/vnd.api+json',
      'User-Agent' => 'Faraday v0.12.2' }
  end
end
