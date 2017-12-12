# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Receptacle, type: :model do
  it 'must have a barcode' do
    receptacle = create(:receptacle)
    expect(receptacle.barcode).to eq("TRAC-#{receptacle.id}")
  end
end
