# frozen_string_literal: true

puts 'Creating Metric Types...'
consumption_type = MetricType.find_or_create_by(code: 'electricity_consumption', name: 'Electricity Consumption',
                                                description: 'The amount of electricity consumed.')
voltage_type = MetricType.find_or_create_by(code: 'electricity_voltage', name: 'Voltage Level',
                                            description: 'The voltage level of the electricity.')

start_time = Time.current - 1.month
end_time = Time.current

puts "Generating metrics from #{start_time} to #{end_time}..."

metrics = []

(start_time.to_i..end_time.to_i).step(1.second) do |timestamp|
  timestamp = Time.at(timestamp).utc

  metrics << {
    metric_type_id: consumption_type.id,
    value: rand(100..500),
    timestamp:
  }
  metrics << {
    metric_type_id: voltage_type.id,
    value: rand(220..240),
    timestamp:
  }

  if metrics.size >= 3600
    puts "Inserting batch at #{timestamp}"
    Metric.insert_all(metrics)
    metrics = []
  end
end

Metric.insert_all(metrics) if metrics.any?

puts 'Metrics creation completed.'
