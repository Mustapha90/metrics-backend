# frozen_string_literal: true

class AggregatesRetrievalService
  FREQUENCY_SETTINGS = {
    '1m' => { table: MetricsAggs1m, max_points: 120 },  # Last 2 hours
    '1h' => { table: MetricsAggs1h, max_points: 168 },  # Last week
    '1d' => { table: MetricsAggs1d, max_points: 30 }    # Last month
  }.freeze

  PER_PAGE = 25

  def initialize(metric_type_code, frequency, page, per_page)
    @metric_type = MetricType.find_by(code: metric_type_code)
    @frequency = frequency
    @page = page
    @per_page = per_page || PER_PAGE
  end

  def call
    return nil unless valid?

    frequency_setting = FREQUENCY_SETTINGS[@frequency]

    metrics = frequency_setting[:table]
              .where(metric_type_id: @metric_type.id)
              .limit(frequency_setting[:max_points])

    Kaminari.paginate_array(metrics).page(@page).per(@per_page)
  end

  private

  def valid?
    @metric_type.present? && FREQUENCY_SETTINGS.key?(@frequency)
  end
end
