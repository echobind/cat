class InitializeClubhouseWorker < BaseClubhouseWorker
  include CustomUtilities
  include ProjectEpicsHelper

  # The main entry point into the workflow, just
  # like a normal Sidekiq job
  def perform(projects_id_array, projects_names_array, user_id)
    step_1_create_destination_projects(projects_id_array, projects_names_array, user_id)
  end

  def step_1_create_destination_projects(projects_id_array, projects_names_array, user_id)
    create_destination_projects_batch = Sidekiq::Batch.new
    create_destination_projects_batch.on(
      :success, "#{self.class}#step_2_create_destination_epics",
      projects_id_array: projects_id_array,
      user_id: user_id
    )
    create_destination_projects_batch.jobs do
      projects_names_array.each do |project_name|
        CreateDestinationProjectWorker.perform_async(project_name, user_id)
      end
    end
  end

  def step_2_create_destination_epics(_status, options)
    epics_array = get_selected_project_epics(convert_string_array_to_integer_array(options["projects_id_array"]))
    user_id = options["user_id"]

    create_destination_epics_batch = Sidekiq::Batch.new
    create_destination_epics_batch.on(
      :success, "#{self.class}#step_3_create_destination_stories",
      epics_array: epics_array,
      user_id: user_id
    )
    create_destination_epics_batch.jobs do
      epics_array.each do |epic|
        CreateDestinationEpicWorker.perform_async(epic, user_id)
      end

      # Ensure batch has at least 1 job so callbacks are run.
      # Required to go to next step in case a project has no associated epics.
      NullWorker.perform_async if epics_array.empty?
    end
  end

  def step_3_create_destination_stories(_status, options)
    template_epics_array = options["epics_array"]
    user_id = options["user_id"]

    create_destination_stories_batch = Sidekiq::Batch.new
    create_destination_stories_batch.on(
      :success, "#{self.class}#step_4_final"
    )
    create_destination_stories_batch.jobs do
      template_epics_array.each do |epic|
        epic_id = epic["id"]
        template_epic_stories = self.class.get("/epics/#{epic_id}/stories", body: { token: CLUBHOUSE_TEMPLATE_API_TOKEN })

        template_epic_stories.each do |story|
          CreateDestinationStoryWorker.perform_async(story, user_id)
        end
      end

      # Ensure batch has at least 1 job so callbacks are run.
      # Required to go to next step in case a project has no associated epics.
      NullWorker.perform_async if template_epics_array.empty?
    end
  end

  def step_4_final(_status, _options)
    puts("DONE")
  end
end
