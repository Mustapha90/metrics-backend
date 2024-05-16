# frozen_string_literal: true

module Api
  module V1
    module Metrics
      class AggregatesController < ApplicationController
        before_action :validate_params

        def show
          service = AggregatesRetrievalService.new(params[:metric_type], params[:frequency], params[:page],
                                                   params[:per_page])
          metrics = service.call

          if metrics
            render json: build_response(metrics), status: :ok
          else
            render json: { errors: [{ message: 'Invalid parameters' }] }, status: :bad_request
          end
        end

        private

        def validate_params
          validator = AggregatesParamsValidator.new(params)
          return if validator.valid?

          render json: { errors: validator.errors }, status: :bad_request
        end

        def build_response(metrics)
          metric_type = MetricType.find_by(code: params[:metric_type])

          {
            metadata: {
              metric_type: metric_type.as_json(only: %i[code name description]),
              frequency: params[:frequency],
              total_pages: metrics.total_pages,
              current_page: metrics.current_page,
              next_page: metrics.next_page,
              prev_page: metrics.prev_page,
              total_count: metrics.total_count
            },
            data: metrics.as_json(methods: :timestamp, only: %i[timestamp avg_value max_value min_value])
          }
        end
      end
    end
  end
end
