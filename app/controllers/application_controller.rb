class ApplicationController < ActionController::API
  include Response

  before_action :authorized

  def logged_in_user
    helper = Helper.new(request)

    return unless helper.decoded_token

    user_id = helper.decoded_token[0]['user_id']
    @user = User.find_by(id: user_id)
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end

  def find_error(resource_type)
    render json: { message: "Cannot find #{resource_type}" }, status: 404
  end

  def valid?(value)
    result = JSON.parse(value)

    result.is_a?(Hash) || result.is_a?(Array)
  rescue JSON::ParserError, TypeError
    false
  end

  helper_method :valid?
end
