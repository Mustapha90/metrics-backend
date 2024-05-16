class CreateMetrics < ActiveRecord::Migration[7.1]
  def change
    hypertable_options = {
      time_column: 'timestamp',
      chunk_time_interval: '1 day',
      compress_segmentby: 'metric_type_id',
      compression_interval: '7 days'
    }

    create_table :metrics, id: false, hypertable: hypertable_options do |t|
      t.references :metric_type, null: false, foreign_key: true, index: true
      t.float :value
      t.column :timestamp, :timestamptz, null: false
      t.timestamps
    end

    add_index :metrics, [:metric_type_id, :timestamp], name: 'index_metrics_on_type_and_timestamp'
  end
end
