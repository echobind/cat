class CreateDestinationEpicWorker < BaseClubhouseWorker
    def perform(epic)
        self.class.post('/epics', :body=> {:token => CLUBHOUSE_DESTINATION_API_TOKEN, :name => epic['name']})
    end
end