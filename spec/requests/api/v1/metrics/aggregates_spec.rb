require 'swagger_helper'

RSpec.describe 'api/v1/metrics/aggregates', type: :request do
  before(:each) do
    host! 'localhost:3000'
  end

  path '/api/v1/metrics/aggs/{metric_type}/{frequency}' do
    parameter name: :metric_type, in: :path, type: :string, description: 'Metric type'
    parameter name: :frequency, in: :path, type: :string, description: 'Frequency'

    get('show aggregates') do
      response(200, 'successful') do
        context 'with frequency 1m' do
          let(:metric_type) { 'electricity_consumption' }
          let(:frequency) { '1m' }

          after do |example|
            content = example.metadata[:response][:content] || {}
            example_spec = {
              'application/json' => {
                examples: {
                  test_example: {
                    value: JSON.parse(response.body, symbolize_names: true)
                  }
                }
              }
            }
            example.metadata[:response][:content] = content.deep_merge(example_spec)
          end
          run_test!
        end

        context 'with frequency 1h' do
          let(:metric_type) { 'electricity_consumption' }
          let(:frequency) { '1h' }

          after do |example|
            content = example.metadata[:response][:content] || {}
            example_spec = {
              'application/json' => {
                examples: {
                  test_example: {
                    value: JSON.parse(response.body, symbolize_names: true)
                  }
                }
              }
            }
            example.metadata[:response][:content] = content.deep_merge(example_spec)
          end
          run_test!
        end

        context 'with frequency 1d' do
          let(:metric_type) { 'electricity_consumption' }
          let(:frequency) { '1d' }

          after do |example|
            content = example.metadata[:response][:content] || {}
            example_spec = {
              'application/json' => {
                examples: {
                  test_example: {
                    value: JSON.parse(response.body, symbolize_names: true)
                  }
                }
              }
            }
            example.metadata[:response][:content] = content.deep_merge(example_spec)
          end
          run_test!
        end
      end

      response(400, 'invalid parameters') do
        context 'with invalid metric_type' do
          let(:metric_type) { 'invalid_type' }
          let(:frequency) { '1m' }

          after do |example|
            content = example.metadata[:response][:content] || {}
            example_spec = {
              'application/json' => {
                examples: {
                  test_example: {
                    value: JSON.parse(response.body, symbolize_names: true)
                  }
                }
              }
            }
            example.metadata[:response][:content] = content.deep_merge(example_spec)
          end
          run_test!
        end

        context 'with invalid frequency' do
          let(:metric_type) { 'electricity_consumption' }
          let(:frequency) { 'invalid_frequency' }

          after do |example|
            content = example.metadata[:response][:content] || {}
            example_spec = {
              'application/json' => {
                examples: {
                  test_example: {
                    value: JSON.parse(response.body, symbolize_names: true)
                  }
                }
              }
            }
            example.metadata[:response][:content] = content.deep_merge(example_spec)
          end
          run_test!
        end
      end
    end
  end
end
