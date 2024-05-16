# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetricsAggs1m, type: :model do
  describe 'associations' do
    it { should belong_to(:metric_type) }
  end
end
