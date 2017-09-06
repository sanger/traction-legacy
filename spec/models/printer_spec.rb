# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Printer, type: :model do
  it 'must have a name' do
    expect(build(:printer, name: nil)).to_not be_valid
  end
end
