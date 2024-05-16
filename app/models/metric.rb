class Metric < ApplicationRecord
  belongs_to :metric_type
  acts_as_hypertable time_column: :timestamp

  validates :value, presence: true
  validates :timestamp, presence: true
end
