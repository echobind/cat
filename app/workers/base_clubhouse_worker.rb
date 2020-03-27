class BaseClubhouseWorker
    include Sidekiq::Worker
    include HTTParty
    base_uri 'https://api.clubhouse.io/api/v3'
end