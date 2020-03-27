class ApplicationController < ActionController::Base
  include HTTParty
  include CustomUtilities
  base_uri 'https://api.clubhouse.io/api/v3'
  CLUBHOUSE_TEMPLATE_API_TOKEN = ENV['CLUBHOUSE_TEMPLATE_API_TOKEN']
  CLUBHOUSE_DESTINATION_API_TOKEN = ENV['CLUBHOUSE_DESTINATION_API_TOKEN']

  def authenticate_admin!
    redirect_to new_user_session_path unless current_user&.admin?
  end
end
