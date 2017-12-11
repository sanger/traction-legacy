# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProcessStep, type: :model do
  it 'can find metadata field by name' do
    process_step = create :process_step_with_metadata_fields
    metadata_field = process_step.metadata_fields.first
    expect(process_step.find_metadata_field(metadata_field.name)).to eq metadata_field
    expect(process_step.find_metadata_field('test')).to eq nil
  end
end
