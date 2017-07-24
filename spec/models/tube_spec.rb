# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tube, type: :model do

  it 'must have a barcode' do
    tube = create(:tube)
    expect(tube.barcode).to eq("TRAC-#{tube.id}")
  end

end
