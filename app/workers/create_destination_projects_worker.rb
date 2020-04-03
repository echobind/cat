class CreateDestinationProjectsWorker < BaseClubhouseWorker
  base_uri "https://api.clubhouse.io/api/v3"

  def perform(projects_name_array)
    projects_name_array.each do |name|
      CreateDestinationProjectWorker.perform_async(name)
    end
  end
end
