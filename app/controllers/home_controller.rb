class HomeController < ApplicationController
  def index
    @template_projects = self.class.get('/projects', :body=> {:token => CLUBHOUSE_TEMPLATE_API_TOKEN})
  end
end
