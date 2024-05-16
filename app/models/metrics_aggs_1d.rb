class MetricsAggs1d < ActiveRecord::Base
  self.table_name = 'metrics_aggs_1d'
  belongs_to :metric_type

  def readonly?
   true
  end
end
