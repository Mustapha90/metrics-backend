# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing do |e|
    render json: { errors: [{ message: e.message }] }, status: :bad_request
  end
end
