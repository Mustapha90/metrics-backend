# frozen_string_literal: true

class CreateMinuteAggregateView < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    view_name = 'metrics_aggs_1m'
    query = <<-SQL
      SELECT
        metric_type_id,
        time_bucket('1 minute', timestamp) AS bucket,
        AVG(value) AS avg_value,
        MAX(value) AS max_value,
        MIN(value) AS min_value
      FROM metrics
      GROUP BY metric_type_id, bucket
    SQL

    options = {
      materialized_only: true,
      with_data: false,
      refresh_policies: {
        start_offset: "INTERVAL '1 month'",
        end_offset: "INTERVAL '1 minute'",
        schedule_interval: "INTERVAL '1 minute'"
      }
    }

    create_continuous_aggregate(view_name, query, **options)
  end
end
