class MetricsAggs1h < ActiveRecord::Base
  self.table_name = 'metrics_aggs_1h'
  belongs_to :metric_type

  def readonly?
   true
  end
end
