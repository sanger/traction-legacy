# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetadataItem, type: :model do
  it 'is not valid if value is empty and metadata_field is required' do
    metadata_field = create :required_metadata_field
    lab_event = create :lab_event
    metadata_item = MetadataItem.new(metadata_field: metadata_field, lab_event: lab_event)
    expect(metadata_item.valid?).to be false
    expect(metadata_item.errors.full_messages.count).to eq 1
    expect(metadata_item.errors.full_messages).to include("Value #{metadata_field.name} can not be empty")
  end
end
