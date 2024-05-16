# frozen_string_literal: true

class MetricsAggs1d < ApplicationRecord
  self.table_name = 'metrics_aggs_1d'
  belongs_to :metric_type

  def readonly?
    true
  end

  def timestamp
    self[:bucket]
  end
end
