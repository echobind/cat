class ClubhouseController < ApplicationController
  include SidekiqMediator

  def initialize_clubhouse_setup
    # params['template_projects'] returns an array of key value pairs
    # {template_project_id: template_project_name}
    @projects_array = params["template_projects"]

    if @projects_array
      # InitializeClubhouseWorker.perform_async(@projects_array.keys, @projects_array.values)
      perform_async(InitializeClubhouseWorker, @projects_array.keys, @projects_array.values)
    end

    redirect_to root_url
  end

  def set_destination_workspace_api_key
    current_user.update_attribute(:clubhouse_api_token, params["destination_workspace_api_key"])

    redirect_to root_url
  end

  def delete_destination_workspace_api_key
    current_user.update_attribute(:clubhouse_api_token, nil)

    redirect_to root_url
  end
end
