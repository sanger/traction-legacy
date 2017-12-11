# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataField, type: :model do
  it 'has name, can be required' do
    metadata_field = create :metadata_field, name: 'volume', required: false
    expect(metadata_field.name).to eq 'volume'
    expect(metadata_field.required?).to be false
  end
end
