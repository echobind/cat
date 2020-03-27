class CreateDestinationProjectWorker < BaseClubhouseWorker

    def perform(project_name)
        # self.class.post('/projects', :body=> {:token => API_TOKEN, :name => project_name, :team_id => 19})
        self.class.post('/projects', :body=> {:token => CLUBHOUSE_DESTINATION_API_TOKEN, :name => project_name, :team_id => 150})
    end
end