RSpec.shared_context 'metrics aggregates mocked data' do
  let!(:metric_type) { MetricType.first }

  before do
    @metrics_1m = [
      MetricsAggs1m.new(metric_type_id: metric_type.id, bucket: Time.now, avg_value: 50, max_value: 100, min_value: 0),
      MetricsAggs1m.new(metric_type_id: metric_type.id, bucket: Time.now - 1.minute, avg_value: 60, max_value: 110, min_value: 10),
      MetricsAggs1m.new(metric_type_id: metric_type.id, bucket: Time.now - 2.minutes, avg_value: 70, max_value: 120, min_value: 20)
    ]

    @metrics_1h = [
      MetricsAggs1h.new(metric_type_id: metric_type.id, bucket: Time.now, avg_value: 55, max_value: 105, min_value: 5),
      MetricsAggs1h.new(metric_type_id: metric_type.id, bucket: Time.now - 1.hour, avg_value: 65, max_value: 115, min_value: 15),
      MetricsAggs1h.new(metric_type_id: metric_type.id, bucket: Time.now - 2.hours, avg_value: 75, max_value: 125, min_value: 25)
    ]

    @metrics_1d = [
      MetricsAggs1d.new(metric_type_id: metric_type.id, bucket: Time.now, avg_value: 60, max_value: 110, min_value: 10),
      MetricsAggs1d.new(metric_type_id: metric_type.id, bucket: Time.now - 1.day, avg_value: 70, max_value: 120, min_value: 20),
      MetricsAggs1d.new(metric_type_id: metric_type.id, bucket: Time.now - 2.days, avg_value: 80, max_value: 130, min_value: 30)
    ]

    allow(MetricsAggs1m).to receive(:where).and_return(Kaminari.paginate_array(@metrics_1m).page(1).per(2))
    allow(MetricsAggs1h).to receive(:where).and_return(Kaminari.paginate_array(@metrics_1h).page(1).per(2))
    allow(MetricsAggs1d).to receive(:where).and_return(Kaminari.paginate_array(@metrics_1d).page(1).per(2))
  end
end
