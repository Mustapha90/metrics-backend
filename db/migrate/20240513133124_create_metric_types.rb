class CreateMetricTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :metric_types do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.text :description
      t.timestamps
    end
    add_index :metric_types, :code, unique: true
  end
end
