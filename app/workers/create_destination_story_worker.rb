class CreateDestinationStoryWorker < BaseClubhouseWorker
  def perform(story, user_id)
    @user = User.find(user_id)
    # 1 get template epic id and name
    epic_id = story["epic_id"]
    story_epic = self.class.get("/epics/#{epic_id}", body: { token: CLUBHOUSE_TEMPLATE_API_TOKEN })

    # 2 get template project id and name
    project_id = story["project_id"]
    story_project = self.class.get("/projects/#{project_id}", body: { token: CLUBHOUSE_TEMPLATE_API_TOKEN })

    # 3 filter for related destination epic
    destination_epics = self.class.get("/epics", body: { token: @user.clubhouse_api_token })
    destination_epic = destination_epics.select { |epic| epic["name"] == story_epic["name"] }

    # 4 filter for related destination project
    destination_projects = self.class.get("/projects", body: { token: @user.clubhouse_api_token })
    destination_project = destination_projects.select { |project| project["name"] == story_project["name"] }

    # 5 create story
    self.class.post("/stories", body: { token: @user.clubhouse_api_token, name: story["name"], epic_id: destination_epic[0]["id"], project_id: destination_project[0]["id"] })
  end
end
