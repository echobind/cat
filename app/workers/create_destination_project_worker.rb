class CreateDestinationProjectWorker < BaseClubhouseWorker
  def perform(project_name, user_id)
    @user = User.find(user_id)
    self.class.post("/projects", body: { token: @user.clubhouse_api_token, name: project_name, team_id: 628 })
  end
end
