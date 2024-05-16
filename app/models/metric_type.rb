# frozen_string_literal: true

class MetricType < ApplicationRecord
  has_many :metrics_aggs_1m
  has_many :metrics_aggs_1h
  has_many :metrics_aggs_1d

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
end
