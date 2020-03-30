class CreateDestinationEpicsWorker < BaseClubhouseWorker
    include CustomUtilities
    include ProjectEpicsHelper
    base_uri 'https://api.clubhouse.io/api/v3'

    def perform(projects_id_array)
        epics_array = get_selected_project_epics(convert_string_array_to_integer_array(projects_id_array))

        epics_array.each do |epic|
            CreateDestinationEpicWorker.perform_async(epic)
        end
    end
end