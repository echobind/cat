module ProjectEpicsHelper
    CLUBHOUSE_TEMPLATE_API_TOKEN = ENV['CLUBHOUSE_TEMPLATE_API_TOKEN']

    def get_selected_project_epics(project_ids_array)
        all_epics = self.class.get('/epics', :body=> {:token => CLUBHOUSE_TEMPLATE_API_TOKEN})

        # puts('epic 0', all_epics.select { |epic| (epic['project_ids'] - project_ids_array).empty? })

        # puts('filtered_epics', all_epics.select { |epic| (epic['project_ids'] - project_ids_array).empty? })

        filtered_epics = all_epics.select { |epic| (epic['project_ids'] - project_ids_array).empty? }
    end
end