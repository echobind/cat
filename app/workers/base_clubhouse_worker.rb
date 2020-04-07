class BaseClubhouseWorker
  include Sidekiq::Worker
  include HTTParty
  base_uri "https://api.clubhouse.io/api/v3"
  CLUBHOUSE_TEMPLATE_API_TOKEN = ENV["CLUBHOUSE_TEMPLATE_API_TOKEN"]
end
