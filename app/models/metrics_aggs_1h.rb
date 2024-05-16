# frozen_string_literal: true

class MetricsAggs1h < ApplicationRecord
  self.table_name = 'metrics_aggs_1h'
  belongs_to :metric_type

  def readonly?
    true
  end

  def timestamp
    self[:bucket]
  end
end
