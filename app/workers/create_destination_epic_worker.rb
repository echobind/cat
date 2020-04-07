class CreateDestinationEpicWorker < BaseClubhouseWorker
  def perform(epic, user_id)
    @user = User.find(user_id)
    self.class.post("/epics", body: { token: @user.clubhouse_api_token, name: epic["name"] })
  end
end
