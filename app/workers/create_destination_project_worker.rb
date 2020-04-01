class CreateDestinationProjectWorker < BaseClubhouseWorker

    def perform(project_name)
        @user = User.find(1)
        # self.class.post('/projects', :body=> {:token => API_TOKEN, :name => project_name, :team_id => 19})
        self.class.post('/projects', :body=> {:token => @user.clubhouse_api_token, :name => project_name, :team_id => 278})
    end
end