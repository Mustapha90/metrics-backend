class MetricsAggs1m < ActiveRecord::Base
  self.table_name = 'metrics_aggs_1m'
  belongs_to :metric_type

  def readonly?
   true
  end
end
