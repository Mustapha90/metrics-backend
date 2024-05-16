class AggregatesRetrievalService
  FREQUENCY_TABLES = {
    '1m' => MetricsAggs1m,
    '1h' => MetricsAggs1h,
    '1d' => MetricsAggs1d
  }.freeze

  def initialize(metric_type_code, frequency, page, per_page)
    @metric_type = MetricType.find_by(code: metric_type_code)
    @frequency = frequency
    @page = page
    @per_page = per_page
  end

  def call
    return nil unless valid?

    FREQUENCY_TABLES[@frequency].where(metric_type_id: @metric_type.id).page(@page).per(@per_page)
  end

  private

  def valid?
    @metric_type.present? && FREQUENCY_TABLES.key?(@frequency)
  end
end
