class AggregatesParamsValidator
  attr_reader :errors

  FREQUENCIES = ['1m', '1h', '1d'].freeze

  def initialize(params)
    @metric_type_code = params[:metric_type]
    @frequency = params[:frequency]
    @errors = []
  end

  def valid?
    validate_metric_type
    validate_frequency
    @errors.empty?
  end

  private

  def validate_metric_type
    unless MetricType.exists?(code: @metric_type_code)
      @errors << { message: "Metric type not found" }
    end
  end

  def validate_frequency
    unless FREQUENCIES.include?(@frequency)
      @errors << { message: "Invalid frequency specified" }
    end
  end
end
