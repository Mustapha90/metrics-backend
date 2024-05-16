# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AggregatesParamsValidator, type: :model do
  let(:valid_metric_type) { MetricType.first }
  let(:valid_params) { { metric_type: valid_metric_type.code, frequency: '1m' } }
  let(:invalid_metric_type_params) { { metric_type: 'invalid_type', frequency: '1m' } }
  let(:invalid_frequency_params) { { metric_type: valid_metric_type.code, frequency: 'invalid_frequency' } }

  describe '#valid?' do
    context 'when parameters are valid' do
      it 'returns true' do
        validator = AggregatesParamsValidator.new(valid_params)
        expect(validator.valid?).to be(true)
      end

      it 'has no errors' do
        validator = AggregatesParamsValidator.new(valid_params)
        validator.valid?
        expect(validator.errors).to be_empty
      end
    end

    context 'when metric type is invalid' do
      it 'returns false' do
        validator = AggregatesParamsValidator.new(invalid_metric_type_params)
        expect(validator.valid?).to be(false)
      end

      it 'has an appropriate error message' do
        validator = AggregatesParamsValidator.new(invalid_metric_type_params)
        validator.valid?
        expect(validator.errors).to include({ message: 'Metric type not found' })
      end
    end

    context 'when frequency is invalid' do
      it 'returns false' do
        validator = AggregatesParamsValidator.new(invalid_frequency_params)
        expect(validator.valid?).to be(false)
      end

      it 'has an appropriate error message' do
        validator = AggregatesParamsValidator.new(invalid_frequency_params)
        validator.valid?
        expect(validator.errors).to include({ message: 'Invalid frequency specified' })
      end
    end
  end
end
