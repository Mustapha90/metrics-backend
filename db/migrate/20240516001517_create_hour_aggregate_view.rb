# frozen_string_literal: true

class CreateHourAggregateView < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!

  def up
    view_name = 'metrics_aggs_1h'
    query = <<-SQL
      SELECT
        metric_type_id,
        time_bucket('1 hour', bucket) AS bucket,
        AVG(avg_value) AS avg_value,
        MAX(max_value) AS max_value,
        MIN(min_value) AS min_value
      FROM metrics_aggs_1m
      GROUP BY 1, 2
    SQL

    options = {
      materialized_only: true,
      with_data: false,
      refresh_policies: {
        start_offset: "INTERVAL '1 month'",
        end_offset: "INTERVAL '1 hour'",
        schedule_interval: "INTERVAL '1 hour'"
      }
    }

    create_continuous_aggregate(view_name, query, **options)
  end
end
