require 'rails_helper'

RSpec.describe AggregatesRetrievalService do
  include_context 'metrics aggregates mocked data'

  describe '#call' do
    context 'with valid metric type and frequency' do
      it 'returns paginated results for 1m frequency' do
        service = AggregatesRetrievalService.new('electricity_consumption', '1m', 1, 2)
        result = service.call

        expect(result.size).to eq(2)
        expect(result.first).to be_a(MetricsAggs1m)
        expect(result.first).to respond_to(:timestamp)
      end

      it 'returns paginated results for 1h frequency' do
        service = AggregatesRetrievalService.new('electricity_consumption', '1h', 1, 2)
        result = service.call

        expect(result.size).to eq(2)
        expect(result.first).to be_a(MetricsAggs1h)
        expect(result.first).to respond_to(:timestamp)
      end

      it 'returns paginated results for 1d frequency' do
        service = AggregatesRetrievalService.new('electricity_consumption', '1d', 1, 2)
        result = service.call

        expect(result.size).to eq(2)
        expect(result.first).to be_a(MetricsAggs1d)
        expect(result.first).to respond_to(:timestamp)
      end
    end

    context 'with invalid metric type or frequency' do
      it 'returns nil for invalid metric type' do
        service = AggregatesRetrievalService.new('invalid_type', '1m', 1, 2)
        result = service.call

        expect(result).to be_nil
      end

      it 'returns nil for invalid frequency' do
        service = AggregatesRetrievalService.new('electricity_consumption', 'invalid_frequency', 1, 2)
        result = service.call

        expect(result).to be_nil
      end
    end
  end

  describe '#valid?' do
    it 'returns true for valid metric type and frequency' do
      service = AggregatesRetrievalService.new('electricity_consumption', '1m', 1, 2)
      expect(service.send(:valid?)).to be(true)
    end

    it 'returns false for invalid metric type' do
      service = AggregatesRetrievalService.new('invalid_type', '1m', 1, 2)
      expect(service.send(:valid?)).to be(false)
    end

    it 'returns false for invalid frequency' do
      service = AggregatesRetrievalService.new('electricity_consumption', 'invalid_frequency', 1, 2)
      expect(service.send(:valid?)).to be(false)
    end
  end
end
