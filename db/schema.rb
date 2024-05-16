# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_05_16_001527) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "timescaledb"

  create_table "metric_types", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_metric_types_on_code", unique: true
  end

  create_table "metrics", id: false, force: :cascade do |t|
    t.bigint "metric_type_id", null: false
    t.float "value"
    t.timestamptz "timestamp", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["metric_type_id", "timestamp"], name: "index_metrics_on_type_and_timestamp"
    t.index ["metric_type_id"], name: "index_metrics_on_metric_type_id"
    t.index ["timestamp"], name: "metrics_timestamp_idx", order: :desc
  end

  add_foreign_key "metrics", "metric_types"
  create_hypertable "metrics", time_column: "timestamp", chunk_time_interval: "1 day", compress_segmentby: "metric_type_id", compress_orderby: "created_at ASC, timestamp DESC", compression_interval: "P7D"
  create_continuous_aggregate("metrics_aggs_1m", <<-SQL, refresh_policies: { start_offset: "INTERVAL 'P1M'", end_offset: "INTERVAL 'PT1M'", schedule_interval: "INTERVAL '60'"}, materialized_only: true, finalized: true)
    SELECT metrics.metric_type_id,
      time_bucket('PT1M'::interval, metrics."timestamp") AS bucket,
      avg(metrics.value) AS avg_value,
      max(metrics.value) AS max_value,
      min(metrics.value) AS min_value
     FROM metrics
    GROUP BY metrics.metric_type_id, (time_bucket('PT1M'::interval, metrics."timestamp"))
  SQL

  create_continuous_aggregate("metrics_aggs_1h", <<-SQL, refresh_policies: { start_offset: "INTERVAL 'P1M'", end_offset: "INTERVAL 'PT1H'", schedule_interval: "INTERVAL '3600'"}, materialized_only: true, finalized: true)
    SELECT metrics_aggs_1m.metric_type_id,
      time_bucket('PT1H'::interval, metrics_aggs_1m.bucket) AS bucket,
      avg(metrics_aggs_1m.avg_value) AS avg_value,
      max(metrics_aggs_1m.max_value) AS max_value,
      min(metrics_aggs_1m.min_value) AS min_value
     FROM metrics_aggs_1m
    GROUP BY metrics_aggs_1m.metric_type_id, (time_bucket('PT1H'::interval, metrics_aggs_1m.bucket))
  SQL

  create_continuous_aggregate("metrics_aggs_1d", <<-SQL, refresh_policies: { start_offset: "INTERVAL 'P1M'", end_offset: "INTERVAL 'P1D'", schedule_interval: "INTERVAL '86400'"}, materialized_only: true, finalized: true)
    SELECT metrics_aggs_1h.metric_type_id,
      time_bucket('P1D'::interval, metrics_aggs_1h.bucket) AS bucket,
      avg(metrics_aggs_1h.avg_value) AS avg_value,
      max(metrics_aggs_1h.max_value) AS max_value,
      min(metrics_aggs_1h.min_value) AS min_value
     FROM metrics_aggs_1h
    GROUP BY metrics_aggs_1h.metric_type_id, (time_bucket('P1D'::interval, metrics_aggs_1h.bucket))
  SQL

end
