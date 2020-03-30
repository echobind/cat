class InitializeClubhouseWorker < BaseClubhouseWorker
    include CustomUtilities
    include ProjectEpicsHelper

    # The main entry point into the workflow, just 
    # like a normal Sidekiq job 
    def perform(projects_id_array, projects_names_array)
        step_1_create_destination_projects(projects_id_array, projects_names_array)
    end

    def step_1_create_destination_projects(projects_id_array, projects_names_array)
        create_destination_projects_batch = Sidekiq::Batch.new
        create_destination_projects_batch.on(
            :success, "#{self.class}#step_2_create_destination_epics",
            :projects_id_array => projects_id_array
        )
        create_destination_projects_batch.jobs do
            projects_names_array.each do |name|
                CreateDestinationProjectWorker.perform_async(name)
            end
        end
    end

    def step_2_create_destination_epics(status, options)
        epics_array = get_selected_project_epics(convert_string_array_to_integer_array(options["projects_id_array"]))

        create_destination_epics_batch = Sidekiq::Batch.new
        create_destination_epics_batch.on(
            :success, "#{self.class}#step_3_final"
        )
        create_destination_epics_batch.jobs do
            puts('empty?', epics_array)
            epics_array.each do |epic|
                CreateDestinationEpicWorker.perform_async(epic)
            end

            # Ensure batch has at least 1 job so callbacks are run. 
            # Required to go to next step in case a project has no associated epics.
            NullWorker.perform_async if epics_array.empty?
        end
    end

    def step_3_final(status, options)
        puts('ALL DONE')
    end
end