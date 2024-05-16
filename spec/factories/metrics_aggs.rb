# frozen_string_literal: true

FactoryBot.define do
  factory :metrics_aggs_1m do
    association :metric_type
    bucket { Time.zone.now }
    avg_value { rand(1.0..100.0).round(2) }
    max_value { rand(1.0..100.0).round(2) }
    min_value { rand(1.0..100.0).round(2) }
  end

  factory :metrics_aggs_1h do
    association :metric_type
    bucket { Time.zone.now }
    avg_value { rand(1.0..100.0).round(2) }
    max_value { rand(1.0..100.0).round(2) }
    min_value { rand(1.0..100.0).round(2) }
  end

  factory :metrics_aggs_1d do
    association :metric_type
    bucket { Time.zone.now }
    avg_value { rand(1.0..100.0).round(2) }
    max_value { rand(1.0..100.0).round(2) }
    min_value { rand(1.0..100.0).round(2) }
  end
end
