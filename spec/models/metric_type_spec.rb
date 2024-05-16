# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MetricType, type: :model do
  describe 'validations' do
    before do
      create(:metric_type, code: 'existing_code', name: 'Existing Name')
    end

    it { should validate_presence_of(:code) }
    it { should validate_uniqueness_of(:code) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end

  describe 'associations' do
    it { should have_many(:metrics_aggs_1m) }
    it { should have_many(:metrics_aggs_1h) }
    it { should have_many(:metrics_aggs_1d) }
  end
end
