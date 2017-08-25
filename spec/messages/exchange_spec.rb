# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Messages::Exchange, type: :model do
  subject(:our_exchange) { described_class.new(channel: channel, exchange: 'test') }

  let(:channel) { instance_double(Bunny::Channel) }
  let(:exchange) { instance_double(Bunny::Exchange) }
  let(:message) { double('message', payload: '{}', routing_key: 'test.message.example.5') }

  describe '#<<' do
    subject { our_exchange << message }

    before do
      expect(channel).to receive(:topic)
        .with('test', auto_delete: false, durable: true)
        .and_return(exchange)
      expect(exchange).to receive(:publish)
        .with('{}', routing_key: 'test.message.example.5')
    end

    it { is_expected.to be_a Messages::Exchange }
  end

end
