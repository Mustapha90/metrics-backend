# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  get 'up' => 'rails/health#show', as: :rails_health_check

  namespace :api do
    namespace :v1 do
      namespace :metrics do
        get 'aggs/:metric_type/:frequency', to: 'aggregates#show', as: :aggregates
      end
    end
  end
end
