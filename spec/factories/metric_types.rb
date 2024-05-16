FactoryBot.define do
  factory :metric_type do
    sequence(:code) { |n| "metric_type_#{n}" }
    sequence(:name) { |n| "Metric Type #{n}" }
    description { "Description for metric type" }
  end
end
